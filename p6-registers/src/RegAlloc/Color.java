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
        // TODO
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
        // TODO
    }

    /*
     * Adjacency changes as nodes are selected and coalesced, corresponding to
     * removing them from the interference graph.
     */
    LinkedHashSet<Node> Adjacent(Node n) {
        LinkedHashSet<Node> adj = new LinkedHashSet<Node>(n.succs);
        adj.removeAll(selectStack);
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

    void Simplify() {
        // TODO
    }

    int Degree(Node n) {
        Integer d = degree.get(n);
        if (d == null)
            return 0;
        return d;
    }

    void Coalesce() {
        // TODO
    }

    void Freeze() {
        // TODO
    }

    void SelectSpill() {
        // TODO
    }

    void AssignColors() {
        // TODO
    }

    private <R> void SetRem(java.util.Collection<R> set, R e) {
        if (!set.remove(e))
            Error(e);
    }

    private <R> void SetAdd(java.util.Collection<R> set, R e) {
        if (!set.add(e))
            Error(e);
    }

    private <R> String Error(R e) {
        String error = "";
        if (e instanceof Node) {
            Node n = (Node) e;
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
        } else if (e instanceof Move) {
            Move m = (Move) e;
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
                // System.err.println("Simplify");
                Simplify();
            } else if (!worklistMoves.isEmpty()) {
                // System.err.println("Coalesce");
                Coalesce();
            } else if (!freezeWorklist.isEmpty()) {
                // System.err.println("Freeze");
                Freeze();
            } else if (!spillWorklist.isEmpty()) {
                // System.err.println("SelectSpill");
                SelectSpill();
            }
        } while (!(simplifyWorklist.isEmpty() && worklistMoves.isEmpty()
            && freezeWorklist.isEmpty() && spillWorklist.isEmpty()));
        AssignColors();
    }

}
