/* Copyright (C) 1997-2012, Antony L Hosking.
 * All rights reserved.  */
package x64;

import java.math.BigInteger;
import java.util.*;

import Assem.Instr;
import Translate.Temp;
import Translate.Tree;
import Translate.Temp.*;
import Translate.Tree.*;
import Translate.Tree.Exp.*;
import Translate.Tree.Stm.*;

public class Codegen implements Frame.CodeGen {
    public Codegen(Frame f) {}

    final LinkedList<Instr> insns = new LinkedList<Instr>();
    public LinkedList<Instr> insns() { return insns; }

    static Instr MOVE(Temp d, Temp s) {
        return new Instr.MOVE("\tmovq `s0,`d0", d, s);
    }

    private static Temp[] T(Temp... a) {
        return a;
    }

    static Instr OPER(String a, Temp[] d, Temp[] s, Label... j) {
        return new Instr.OPER("\t" + a, d, s, j);
    }

    public Temp visit(MOVE s) {
        // TODO [DONE]
        if (!(s.dst instanceof MEM memDst)) {
            if (!CONST32(s.src)) {
                // MOVE(Exp, Exp)
                final Temp dst = s.dst.accept(this);
                final Temp src = s.src.accept(this);
                this.insns.add(MOVE(dst, src));
                return dst;
            }
            // MOVE(Exp, CONST32)
            final CONST constSrc = (CONST) s.src;
            final Temp dst = s.dst.accept(this);
            if (constSrc.value.signum() == 0) {
                // MOVE(Exp, $0)
                this.insns.add(OPER(
                        "xorq `s0,`d0",
                        T(dst), T(dst)
                ));
            } else {
                this.insns.add(OPER(
                        "movq $" + constSrc.value + ",`d0",
                        T(dst), T()
                ));
            }
            return dst;
        }
        assert memDst.size == Frame.wordSize;
        if (!CONST32(memDst.offset)) {
            // MOVE(MEM, Exp)
            final Temp exp = memDst.exp.accept(this);
            final Temp off = memDst.offset.accept(this);
            final Temp src = s.src.accept(this);
            this.insns.add(OPER(
                    "movq `s0,`s1(`s2)",
                    T(), T(src, off, exp)
            ));
            return null;
        }
        // MOVE(MEM(Exp, CONST32), Exp)
        String offset = String.valueOf(memDst.offset.value);
        if (memDst.exp instanceof NAME dstName) {
            final Temp addr = new Temp();
            this.insns.add(OPER(
                    "leaq " + dstName.label + "(" + Frame.RIP + "),`d0",
                    T(addr), T()
            ));
            if (CONST32(s.src)) {
                // MOVE(MEM(Exp, CONST32), CONST32)
                final String literalSource = String.valueOf(((CONST) s.src).value);
                this.insns.add(OPER(
                        "movq $" + literalSource + "," + offset + "(`s0)",
                        T(), T(addr)
                ));
            } else {
                // MOVE(MEM(Exp, CONST32), Exp)
                final Temp src = s.src.accept(this);
                this.insns.add(OPER(
                        "movq `s0," + offset + "(`s1)",
                        T(), T(src, addr)
                ));
            }
            return null;
        }
        final Temp exp = memDst.exp instanceof TEMP expTemp ? expTemp.temp : memDst.exp.accept(this);
        if (CONST32(s.src)) {
            final String literalSource = String.valueOf(((CONST) s.src).value);
            this.insns.add(OPER(
                    "movq $" + literalSource + "," + offset + "(`s0)",
                    T(), T(exp)
            ));
        } else {
            final Temp src = s.src.accept(this);
            this.insns.add(OPER(
                    "movq `s0," + offset + "(`s1)",
                    T(), T(src, exp)
            ));
        }
        return null;
    }

    public Temp visit(EXP s) {
        return s.exp.accept(this);
    }

    public Temp visit(JUMP s) {
        // TODO [DONE]
        if (s.exp instanceof NAME) {
            // JUMP(NAME)
            this.insns.add(OPER(
                    "jmp `j0",
                    T(), T(), s.targets
            ));
            return null;
        }
        // JUMP(Exp)
        final Temp s0 = s.exp.accept(this);
        this.insns.add(OPER(
                "je `s0",
                T(), T(s0), s.targets
        ));
        return null;
    }

    public Temp visit(CJUMP s) {
        // TODO [DONE]
        final String op = switch (s.op) {
            case BEQ -> "je";
            case BNE -> "jne";
            case BGE -> "jge";
            case BLE -> "jle";
            case BGT -> "jg";
            case BLT -> "jl";
        };
        if (CONST32(s.left) && !CONST32(s.right)) {
            // CJUMP(CONST32, Exp, Label, Label)
            s.swap().accept(this);
            return null;
        } else if (CONST32(s.right)) {
            // CJUMP(Exp, CONST32, Label, Label)
            final CONST c = (CONST) s.right;
            final Temp s0 = s.left.accept(this);
            this.insns.add(OPER(
                    op + " `s0 " + c.value + " `j0",
                    T(), T(s0),
                    s.iftrue, s.iffalse
            ));
            return null;
        }
        final Temp left = s.left.accept(this);
        final Temp right = s.right.accept(this);
        this.insns.add(OPER(
                "cmpq `s0,`s1",
                T(), T(right, left)
        ));
        this.insns.add(OPER(
                op + " `j0",
                T(), T(), s.iftrue, s.iffalse
        ));
        return null;
    }

    public Temp visit(LABEL l) {
        // TODO [DONE]
        this.insns.add(new Instr.LABEL(l.label.toString() + ":", l.label));
        return null;
    }

    public Temp visit(CONST e) {
        // TODO [DONE]
        if (e.value.signum() == 0) {
            // $0
            final Temp d0 = new Temp();
            this.insns.add(OPER(
                    "xorq `s0,`d0",
                    T(d0), T(d0)
            ));
            return d0;
        }
        final Temp d0 = new Temp();
        this.insns.add(OPER(
                "movq $" + e.value + ",`d0",
                T(d0), T()
        ));
        return d0;
    }

    public Temp visit(NAME e) {
        // TODO [DONE]
        // Execute instruction pointer relative addressing, rely on assembler for label offset calculation
        final Temp d0 = new Temp();
        this.insns.add(OPER(
                "leaq " + e.label + "(" + Frame.RIP + "),`d0",
                T(d0), T()
        ));
        return d0;
    }

    public Temp visit(TEMP e) {
        return e.temp;
    }

    static int shift(long i) {
        int shift = 0;
        if ((i > 1) && ((i & (i - 1)) == 0)) {
            while (i > 1) {
                shift += 1;
                i >>= 1;
            }
        }
        return shift;
    }

    private static int shift(BigInteger i) {
        int shift = 0;
        if (i.compareTo(BigInteger.ONE) > 0
            && ((i.and(i.subtract(BigInteger.ONE))).signum() == 0)) {
            while (i.compareTo(BigInteger.ONE) > 0) {
                shift += 1;
                i = i.shiftRight(1);
            }
        }
        return shift;
    }

    private static boolean CONST32(Exp e) {
        return e instanceof CONST c && c.value.bitLength() <= 32;
    }

    public Temp visit(BINOP b) {
        // TODO [DONE]
        String op;
        Exp l = b.left;
        Exp r = b.right;
        switch (b.op) {
            case ADD -> {
                if (CONST32(l) && !CONST32(r)) {
                    // ADD(CONST32, Exp)
                    Exp t = l;
                    l = r;
                    r = t;
                }
                op = "addq";
            }
            case AND -> {
                if (CONST32(l) && !CONST32(r)) {
                    // AND(CONST32, Exp)
                    Exp t = l;
                    l = r;
                    r = t;
                }
                op = "andq";
            }
            case DIV -> {
                if (CONST32(r)) {
                    // DIV(Exp, CONST32)
                    final int shift = shift(((CONST) r).value);
                    if (shift != 0) {
                        // DIV(Exp, CONST 2^k)
                        final Temp d0 = new Temp();
                        final Temp s0 = l.accept(this);
                        this.insns.add(MOVE(d0, s0));
                        this.insns.add(OPER(
                                "sarq $" + shift + ",`d0",
                                T(d0), T()
                        ));
                        return d0;
                    }
                }
                final Temp d0 = new Temp();
                final Temp s0 = l.accept(this);
                final Temp s1 = r.accept(this);
                this.insns.add(MOVE(Frame.RAX, s0));
                this.insns.add(OPER(
                        "cqo",
                        T(), T()
                )); // Sign-extend RAX into RDX
                this.insns.add(OPER(
                        "idivq `s0",
                        T(), T(s1)
                ));
                this.insns.add(MOVE(d0, Frame.RAX)); // Quotient
                return d0;
            }
            case DIVU -> {
                if (CONST32(r)) {
                    // DIVU(Exp, CONST32)
                    final int shift = shift(((CONST) r).value);
                    if (shift != 0) {
                        // DIVU(Exp, CONST 2^k)
                        final Temp d0 = new Temp();
                        final Temp s0 = l.accept(this);
                        this.insns.add(MOVE(d0, s0));
                        this.insns.add(OPER(
                                "shrq $" + shift + ",`d0",
                                T(d0), T()
                        ));
                        return d0;
                    }
                }
                final Temp d0 = new Temp();
                final Temp s0 = l.accept(this);
                final Temp s1 = r.accept(this);
                this.insns.add(MOVE(Frame.RAX, s0));
                this.insns.add(OPER(
                        "cqo",
                        T(), T()
                )); // Sign-extend RAX into RDX
                this.insns.add(OPER(
                        "divq `s0",
                        T(), T(s1)
                ));
                this.insns.add(MOVE(d0, Frame.RAX)); // Quotient
                return d0;
            }
            case MOD -> {
                // MOD(Exp, Exp)
                final Temp d0 = new Temp();
                final Temp s0 = l.accept(this);
                final Temp s1 = r.accept(this);
                this.insns.add(MOVE(Frame.RAX, s0));
                this.insns.add(OPER(
                        "cqo",
                        T(), T()
                )); // Sign-extend RAX into RDX
                this.insns.add(OPER(
                        "divq `s0",
                        T(), T(s1)
                ));
                this.insns.add(MOVE(d0, Frame.RDX)); // Remainder
                return d0;
            }
            case MUL -> {
                if (CONST32(r)) {
                    // MUL(Exp, CONST32)
                    final int shift = shift(((CONST) r).value);
                    if (shift != 0) {
                        // MUL(Exp, CONST 2^k)
                        final Temp d0 = new Temp();
                        final Temp s0 = l.accept(this);
                        this.insns.add(MOVE(d0, s0));
                        this.insns.add(OPER(
                                "shlq $" + shift + ",`d0",
                                T(d0), T()
                        ));
                        return d0;
                    }
                }
                if (CONST32(l)) {
                    // MUL(CONST32, Exp)
                    final int shift = shift(((CONST) l).value);
                    if (shift != 0) {
                        // MUL(CONST 2^k, Exp)
                        final Temp d0 = new Temp();
                        final Temp s0 = r.accept(this);
                        this.insns.add(MOVE(d0, s0));
                        this.insns.add(OPER(
                                "shlq $" + shift + ",`d0",
                                T(d0), T()
                        ));
                        return d0;
                    }
                }
                if (CONST32(l) && !CONST32(r)) {
                    // MUL(CONST32, Exp)
                    Exp t = l;
                    l = r;
                    r = t;
                }
                op = "imulq";
            }
            case OR -> {
                if (CONST32(l) && !CONST32(r)) {
                    // OR(CONST32, Exp)
                    Exp t = l;
                    l = r;
                    r = t;
                }
                op = "orq";
            }
            case SLL -> op = "shlq";
            case SRA -> op = "sarq";
            case SRL -> op = "shrq";
            case SUB -> {
                if (CONST32(l) && !CONST32(r)) {
                    // SUB(CONST32, Exp)
                    Exp t = l;
                    l = r;
                    r = t;
                }
                op = "subq";
            }
            case XOR -> {
                if (CONST32(l) && !CONST32(r)) {
                    // XOR(CONST32, Exp)
                    Exp t = l;
                    l = r;
                    r = t;
                }
                op = "xorq";
            }
            default -> throw new Error();
        }
        if (CONST32(r)) {
            // BINOP(Expr, CONST32)
            final String constValue = " $" + ((CONST) r).value;
            final Temp d0 = new Temp();
            final Temp s0 = l instanceof TEMP tempL ? tempL.temp : l.accept(this);
            this.insns.add(MOVE(d0, s0));
            this.insns.add(OPER(
                    op + constValue + ",`d0",
                    T(d0), T()
            ));
            return d0;
        }
        // BINOP(Exp, Exp)
        final Temp d0 = new Temp();
        final Temp s0 = l.accept(this);
        final Temp s1 = r.accept(this);
        this.insns.add(MOVE(d0, s1));
        this.insns.add(OPER(
                op + " `s0,`d0",
                T(d0), T(s0)
        ));
        return d0;
    }

    public Temp visit(MEM mem) {
        // TODO [DONE]
        assert mem.size == Frame.wordSize;
        Temp dst = new Temp();
        if (!CONST32(mem.offset)) {
            // MEM(Exp, CONST)
            final Temp exp = mem.exp.accept(this);
            final Temp off = mem.offset.accept(this);
            this.insns.add(OPER(
                    "movq `s0(`s1),`d0",
                    T(dst), T(off,exp)
            ));
            return null;
        }
        // MEM(Exp, CONST32)
        String offset = String.valueOf(mem.offset.value);
        if (mem.exp instanceof NAME expName) {
            // MEM(NAME, CONST32)
            final Temp addr = new Temp();
            this.insns.add(OPER(
                    "leaq " + expName.label + "(" + Frame.RIP + "),`d0",
                    T(addr), T()
            ));
            this.insns.add(OPER(
                    "movq " + offset + "(`s0),`d0",
                    T(dst), T(addr)
            ));
            return dst;
        }
        // MEM(TEMP/Exp, CONST32)
        Temp exp = mem.exp instanceof TEMP expTemp ? expTemp.temp : mem.exp.accept(this);
        this.insns.add(OPER(
                "movq " + offset + "(`s0),`d0",
                T(dst), T(exp)
        ));
        return dst;
    }

    public Temp visit(CALL s) {
        String op;
        LinkedList<Temp> uses = new LinkedList<Temp>();
        if (s.func instanceof NAME n) {
            // CALL(NAME, ...)
            op = "call " + n.label;
        } else {
            // CALL(Exp, ...)
            uses.add(s.func.accept(this));
            op = "call *`s0";
        }
        if (s.link instanceof CONST c) {
            assert c.value.signum() == 0;
        } else {
            insns.add(MOVE(Frame.R10, s.link.accept(this)));
            uses.add(Frame.R10);
        }
        int size = 0;
        for (Tree.Exp arg: s.args) {
            int i = size / Frame.wordSize;
            if (arg instanceof Tree.Exp.MEM mem) {
                if (mem.size == Frame.wordSize) {
                    if (i < Frame.argRegs.length) {
                        Temp d0 = Frame.argRegs[i];
                        Temp s0 = arg.accept(this);
                        if (d0 != s0) insns.add(MOVE(d0, s0));
                        uses.add(d0);
                    } else {
                        insns.add(OPER("movq `s0,"
                                + ((i - Frame.argRegs.length) * Frame.wordSize) + "(`s1)", T(),
                                T(arg.accept(this), Frame.RSP)));
                    }
                } else {
                    Temp s0 = mem.exp.accept(this);
                    for (int k = 0; k < mem.size; k += Frame.wordSize) {
                        new MOVE
                            (new MEM
                             (new TEMP(Frame.RSP),
                              new CONST(BigInteger.valueOf(k + size)),
                              Frame.wordSize),
                             new MEM
                             (new TEMP(s0),
                              new CONST(mem.offset.value.add(BigInteger.valueOf(k))),
                              Frame.wordSize)).accept(this);
                    }
                }
                size += mem.size;
            } else {
                if (i < Frame.argRegs.length) {
                    Temp d0 = Frame.argRegs[i];
                    Temp s0 = arg.accept(this);
                    if (d0 != s0) insns.add(MOVE(d0, s0));
                    uses.add(d0);
                } else {
                    insns.add(OPER("movq `s0,"
                            + ((i - Frame.argRegs.length) * Frame.wordSize) + "(`s1)", T(),
                            T(arg.accept(this), Frame.RSP)));
                }
                size += Frame.wordSize;
            }

        }
        insns.add(OPER(op, Frame.callDefs, uses.toArray(new Temp[uses.size()])));
        return Frame.RAX;
    }

    // Canonical trees shouldn't have SEQ so throw an error
    public Temp visit(SEQ n) {
        throw new Error();
    }

    // Canonical trees shouldn't have ESEQ so throw an error
    public Temp visit(ESEQ n) {
        throw new Error();
    }
}

