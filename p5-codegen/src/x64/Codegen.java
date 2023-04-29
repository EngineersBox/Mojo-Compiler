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
        // TODO
        if (s.dst instanceof MEM dstmem) {

        }
        // MOVE(Exp, Exp)
        Temp dst = s.dst.accept(this);
        Temp src = s.src.accept(this);
        insns.add(MOVE(dst, src));
        return null;
    }

    public Temp visit(EXP s) {
        return s.exp.accept(this);
    }

    public Temp visit(JUMP s) {
        // TODO
        return null;
    }

    public Temp visit(CJUMP s) {
        // TODO
        return null;
    }

    public Temp visit(LABEL l) {
        // TODO [DONE]
        this.insns.add(new Instr.LABEL(l.label.toString() + ":", l.label));
        return null;
    }

    public Temp visit(CONST e) {
        // TODO [DONE]
        final Temp d0 = new Temp();
        this.insns.add(OPER("mov `d0, " + e.value, T(d0), T()));
        return d0;
    }

    public Temp visit(NAME e) {
        // TODO [DONE]
        final Temp d0 = new Temp();
        this.insns.add(OPER("leaq " + e.label + "(%rip),`d0", T(d0), T()));
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
        // TODO
        return null;
    }

    public Temp visit(MEM mem) {
        // TODO
        return null;
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

