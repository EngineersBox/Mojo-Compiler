/* Copyright (C) 1997-2005, Antony L Hosking.
 * All rights reserved.  */
package RegAlloc;

import java.util.*;
import Translate.Temp;

public class Color {
    final InterferenceGraph ig;
    final int K;
    /**
     * The colors available to the allocator.
     */
    final LinkedList<Temp> colors = new LinkedList<Temp>();
    /**
     * Precolored nodes corresponding to the machine registers.
     */
    final LinkedHashSet<Node> precolored = new LinkedHashSet<Node>();

    /**
     * Return the spilled registers from this round of allocation.
     */
    public Temp[] spills() {
        Temp[] spills = null;
        int spillCount = spilledNodes.size();
        if (spillCount > 0) {
            spills = new Temp[spilledNodes.size()];
            int i = 0;
            for (Node n : spilledNodes)
                spills[i++] = n.temp;
        }
        return spills;
    }

    // Node worklists, sets and stacks
    final LinkedHashSet<Node> simplifyWorklist; // low-degree non-move-related nodes
    final LinkedHashSet<Node> freezeWorklist; // low-degree move-related nodes
    final LinkedHashSet<Node> coalescedNodes; // registers that have been coalesced
    final LinkedList<Node> initial; // temporary registers, not precolored and not yet processed
    final LinkedList<Node> spillWorklist; // high-degree nodes
    final LinkedList<Node> spilledNodes; // nodes marked for spilling during this round
    final LinkedList<Node> coloredNodes; // nodes successfully colored
    final LinkedList<Node> selectStack; // stack containing temporaries removed from the graph
    {
        initial = new LinkedList<Node>();
        simplifyWorklist = new LinkedHashSet<Node>();
        freezeWorklist = new LinkedHashSet<Node>();
        spillWorklist = new LinkedList<Node>();
        spilledNodes = new LinkedList<Node>();
        coalescedNodes = new LinkedHashSet<Node>();
        coloredNodes = new LinkedList<Node>();
        selectStack = new LinkedList<Node>();
    }

    /*
     * Move sets. There are five sets of move instructions, and every move is in
     * exactly one of these sets (after Build through end of Color).
     */

    /**
     * Moves enabled for possible coalescing.
     */
    final LinkedList<Move> worklistMoves = new LinkedList<Move>();
    /**
     * Moves that have been coalesced.
     */
    final LinkedHashSet<Move> coalescedMoves = new LinkedHashSet<Move>();
    /**
     * Moves whose source and target interfere.
     */
    final LinkedHashSet<Move> constrainedMoves = new LinkedHashSet<Move>();
    /**
     * Moves no longer considered for coalescing.
     */
    final LinkedHashSet<Move> frozenMoves = new LinkedHashSet<Move>();
    /**
     * Moves not yet ready for coalescing.
     */
    final LinkedHashSet<Move> activeMoves = new LinkedHashSet<Move>();

    /*
     * Other data structures.
     */

    /**
     * Current degree of each node.
     */
    final LinkedHashMap<Node, Integer> degree = new LinkedHashMap<Node, Integer>();
    /**
     * Moves associated with each node.
     */
    final LinkedHashMap<Node, LinkedList<Move>> moveList = new LinkedHashMap<Node, LinkedList<Move>>();
    /**
     * When a move (u,v) has been coalesced, and v put in coalescedNodes, then
     * alias(v) = u
     */
    final LinkedHashMap<Node, Node> alias = new LinkedHashMap<Node, Node>();

    LinkedList<Move> MoveList(Node n) {
        LinkedList<Move> moves = moveList.get(n);
        if (moves == null) {
            moves = new LinkedList<Move>();
            moveList.put(n, moves);
        }
        return moves;
    }

    void Build() {
        // TODO [DONE]
        for (final Move m : ig.moves()) {
            this.moveList.computeIfAbsent(
                    m.src,
                    (final Node n) -> new LinkedList<>()
            ).add(m);
            this.moveList.computeIfAbsent(
                    m.dst,
                    (final Node n) -> new LinkedList<>()
            ).add(m);
            this.worklistMoves.add(m);
        }
    }

    void AddEdge(Node u, Node v) {
        if (u != v && !u.adj(v)) {
            if (!precolored.contains(u)) {
                ig.addEdge(u, v);
                degree.put(u, Degree(u) + 1);
            }
            if (!precolored.contains(v)) {
                ig.addEdge(v, u);
                degree.put(v, Degree(v) + 1);
            }
        }
    }

    void MakeWorkList() {
        // TODO [DONE]
        for (final Node n : this.initial) {
            if (Degree(n) >= this.K) {
                SetAdd(this.spillWorklist, n);
            } else if (MoveRelated(n)) {
                SetAdd(this.freezeWorklist, n);
            } else {
                SetAdd(this.simplifyWorklist, n);
            }
        }
        this.initial.clear();
    }

    /*
     * Adjacency changes as nodes are selected and coalesced, corresponding to
     * removing them from the interference graph.
     */
    LinkedHashSet<Node> Adjacent(Node n) {
        LinkedHashSet<Node> adj = new LinkedHashSet<>(n.succs);
        selectStack.forEach(adj::remove);
        adj.removeAll(coalescedNodes);
        return adj;
    }

    /*
     * A nodes moves change as adjacency changes, and include only those moves
     * still active (not frozen) but not ready for coalescing, or  moves
     * available for coalescing.
     */
    LinkedHashSet<Move> NodeMoves(Node n) {
        LinkedHashSet<Move> moves = new LinkedHashSet<Move>();
        moves.addAll(activeMoves);
        moves.addAll(worklistMoves);
        moves.retainAll(MoveList(n));
        return moves;
    }

    /*
     * A node is move-related if any of its moves are still active
     */
    boolean MoveRelated(Node n) {
        return !NodeMoves(n).isEmpty();
    }

    private <T> LinkedHashSet<T> union(final T singleton,
                                       final LinkedHashSet<T> set) {
        final LinkedHashSet<T> newSet = LinkedHashSet.newLinkedHashSet(1 + set.size());
        newSet.add(singleton);
        newSet.addAll(set);
        return newSet;
    }

    private <T> LinkedHashSet<T> union(final Collection<T> setA,
                                       final Collection<T> setB) {
        final LinkedHashSet<T> newSet = LinkedHashSet.newLinkedHashSet(
                (setA == null ? 0 : setA.size())
                + (setB == null ? 0 : + setB.size())
        );
        if (setA != null) newSet.addAll(setA);
        if (setB != null) newSet.addAll(setB);
        return newSet;
    }

    private <T> LinkedList<T> union(final LinkedList<T> listA,
                                    final LinkedList<T> listB) {
        final LinkedList<T> newSet = new LinkedList<>();
        if (listA != null) newSet.addAll(listA);
        if (listB != null) newSet.addAll(listB);
        return newSet;
    }

    private void enableMoves(final LinkedHashSet<Node> nodes) {
        for (final Node n : nodes) {
            for (final Move m : NodeMoves(n)) {
                if (!this.activeMoves.contains(m)) {
                    continue;
                }
                SetRem(this.activeMoves, m);
                SetAdd(this.worklistMoves, m);
            }
        }
    }

    private void enableMoves(final Node node) {
        final LinkedHashSet<Node> set = LinkedHashSet.newLinkedHashSet(1);
        set.add(node);
        enableMoves(set);
    }

    private void decrementDegree(final Node m) {
        final int d = Degree(m);
        this.degree.put(m, Math.max(d - 1, 0));
        if (d != K) {
            return;
        }
        enableMoves(union(m, Adjacent(m)));
        SetRem(this.spillWorklist, m);
        if (MoveRelated(m)) {
            SetAdd(this.freezeWorklist, m);
        } else {
            SetAdd(this.simplifyWorklist, m);
        }
    }

    void Simplify() {
        // TODO [DONE]
        final Optional<Node> nOpt = this.simplifyWorklist.stream().findFirst();
        if (nOpt.isEmpty()) {
            return;
        }
        final Node n = nOpt.get();
        SetRem(this.simplifyWorklist, n);
        this.selectStack.push(n);
        Adjacent(n).forEach(this::decrementDegree);
    }

    int Degree(final Node n) {
        return Objects.requireNonNullElse(this.degree.get(n), 0);
    }

    private void addWorklist(final Node u) {
        if (!this.precolored.contains(u) && !MoveRelated(u) && Degree(u) < this.K) {
            SetRem(this.freezeWorklist, u);
            SetAdd(this.simplifyWorklist, u);
        }
    }

    private boolean ok(final Node t, final Node r) {
        return Degree(t) < this.K
                || this.precolored.contains(t)
                || t.adj(r);
    }

    private boolean allAdjacent(final Node u, final Node v) {
        return Adjacent(v).stream()
                .allMatch((final Node t) -> ok(t, u));
    }

    private boolean conservative(final LinkedHashSet<Node> nodes) {
        return nodes.stream()
                .map((final Node n) -> Degree(n) >= this.K ? 1 : 0)
                .reduce(Integer::sum).get() < this.K;
    }

    private void combine(final Node u, final Node v) {
        if (this.freezeWorklist.contains(v)) {
            SetRem(this.freezeWorklist, v);
        } else {
            SetRem(this.spillWorklist, v);
        }
        SetAdd(this.coalescedNodes, v);
        this.alias.put(v, u);
        this.moveList.put(u, union(
                this.moveList.get(u),
                this.moveList.get(v)
        ));
        enableMoves(v);
        for (final Node t : Adjacent(v)) {
            AddEdge(t, u);
            decrementDegree(t);
        }
        if (Degree(u) >= this.K && this.freezeWorklist.contains(u)) {
            SetRem(this.freezeWorklist, u);
            SetAdd(this.spillWorklist, u);
        }
    }

    void Coalesce() {
        // TODO [DONE]
        final Move m = this.worklistMoves.getFirst();
        final Node x = getAlias(m.src);
        final Node y = getAlias(m.dst);
        final Node u;
        final Node v;
        if (this.precolored.contains(y)) {
            u = y;
            v = x;
        } else {
            u = x;
            v = y;
        }
        SetRem(this.worklistMoves, m);
        if (u.equals(v)) {
            SetAdd(this.coalescedMoves, m);
            addWorklist(u);
        } else if (this.precolored.contains(v) || u.adj(v) || v.adj(u)) {
            SetAdd(this.constrainedMoves, m);
            addWorklist(u);
            addWorklist(v);
        } else if ((this.precolored.contains(u) && allAdjacent(u, v))
                || (!this.precolored.contains(u) && conservative(union(Adjacent(u), Adjacent(v))))) {
            SetAdd(this.coalescedMoves, m);
            combine(u, v);
            addWorklist(u);
        } else {
            SetAdd(this.activeMoves, m);
        }
    }

    private void freezeMoves(final Node u) {
        for (final Move m : NodeMoves(u)) {
            final Node x = m.src;
            final Node y = m.dst;
            final Node yAlias = getAlias(y);
            final Node v;
            if (yAlias.equals(getAlias(u))) {
                v = getAlias(x);
            } else {
                v = yAlias;
            }
            SetRem(this.activeMoves, m);
            SetAdd(this.frozenMoves, m);
            if (this.freezeWorklist.contains(v) && NodeMoves(v).isEmpty()) {
                SetRem(this.freezeWorklist, v);
                SetAdd(this.simplifyWorklist, v);
            }
        }
    }

    void Freeze() {
        // TODO [DONE]
        final Optional<Node> uOpt = this.freezeWorklist.stream().findFirst();
        if (uOpt.isEmpty()) {
            return;
        }
        final Node u = uOpt.get();
        SetRem(this.freezeWorklist, u);
        SetAdd(this.simplifyWorklist, u);
        freezeMoves(u);
    }

    void SelectSpill() {
        // TODO [DONE]
        final Optional<Node> mOpt = this.spillWorklist.stream()
                .min((final Node a, final Node b) -> {
                    if (a == null) return 1;
                    if (b == null) return -1;
                    final double aHeuristic = a.spillCost / Degree(a);
                    final double bHeuristic = b.spillCost / Degree(b);
                    return Double.compare(aHeuristic, bHeuristic);
                });
        if (mOpt.isEmpty()) {
            return;
        }
        final Node m = mOpt.get();
        SetRem(this.spillWorklist, m);
        SetAdd(this.simplifyWorklist, m);
        freezeMoves(m);
    }

    private Node getAlias(final Node n) {
        if (this.coalescedNodes.contains(n)) {
            return getAlias(this.alias.get(n));
        }
        return n;
    }

    void AssignColors() {
        // TODO [DONE]
        Node n;
        while (!this.selectStack.isEmpty() && (n = this.selectStack.pop()) != null) {
            final LinkedList<Temp> okColours = new LinkedList<>(this.colors);
            final LinkedHashSet<Node> nodesColouredPreColoured = union(
                    this.coloredNodes,
                    this.precolored
            );
            // Node.succs == adjList[n]
            for (final Node w : n.succs) {
                final Node wAlias = getAlias(w);
                if (nodesColouredPreColoured.contains(wAlias)) {
                    okColours.remove(wAlias.color);
                }
            }
            if (okColours.isEmpty()) {
                SetAdd(this.spilledNodes, n);
            } else {
                SetAdd(this.coloredNodes, n);
                n.color = okColours.getFirst();
                System.out.println("=== COLOUR: " + n.color);
            }
        }
        this.coalescedNodes.forEach((final Node node) -> node.color = getAlias(node).color);
    }

    private <R> void SetRem(final Collection<R> set, final R e) {
        if (!set.remove(e))
            Error(e);
    }

    private <R> void SetAdd(final Collection<R> set, final R e) {
        if (!set.add(e))
            Error(e);
    }

    private <R> String Error(R e) {
        String error = "";
        if (e instanceof Node n) {
            error += n.temp + "(" + Degree(n) + "):";
            if (precolored.contains(n))
                error += " precolored";
            if (initial.contains(n))
                error += " initial";
            if (simplifyWorklist.contains(n))
                error += " simplifyWorklist";
            if (freezeWorklist.contains(n))
                error += " freezeWorklist";
            if (spillWorklist.contains(n))
                error += " spillWorklist";
            if (spilledNodes.contains(n))
                error += " spilledNodes";
            if (coalescedNodes.contains(n))
                error += " coalescedNodes";
            if (coloredNodes.contains(n))
                error += " coloredNodes";
            if (selectStack.contains(n))
                error += " selectStack";
        } else if (e instanceof Move m) {
            error += m.dst + "<=" + m.src + ":";
            if (coalescedMoves.contains(m))
                error += " coalescedMoves";
            if (constrainedMoves.contains(m))
                error += " constrainedMoves";
            if (frozenMoves.contains(m))
                error += " frozenMoves";
            if (worklistMoves.contains(m))
                error += " worklistMoves";
            if (activeMoves.contains(m))
                error += " activeMoves";
        }
        throw new Error(error);
    }

    public Color(InterferenceGraph ig, Translate.Frame frame) {
        this.ig = ig;
        this.K = frame.registers().length;
        for (Temp r : frame.registers()) {
            Node n = ig.get(r);
            precolored.add(n);
            colors.add(r);
        }
        for (Node n : ig.nodes())
            if (n.color == null) {
                initial.add(n);
                degree.put(n, n.outDegree());
            }

        Build();
        MakeWorkList();

        do {
            if (!simplifyWorklist.isEmpty()) {
//                 System.err.println("Simplify");
                Simplify();
            } else if (!worklistMoves.isEmpty()) {
//                 System.err.println("Coalesce");
                Coalesce();
            } else if (!freezeWorklist.isEmpty()) {
//                 System.err.println("Freeze");
                Freeze();
            } else if (!spillWorklist.isEmpty()) {
//                 System.err.println("SelectSpill");
                SelectSpill();
            }
        } while (!(simplifyWorklist.isEmpty() && worklistMoves.isEmpty()
            && freezeWorklist.isEmpty() && spillWorklist.isEmpty()));
        AssignColors();
    }

}
