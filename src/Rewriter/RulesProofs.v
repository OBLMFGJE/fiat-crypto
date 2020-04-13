Require Import Coq.micromega.Lia.
Require Import Coq.ZArith.ZArith.
Require Import Crypto.Util.ListUtil Coq.Lists.List Crypto.Util.ListUtil.FoldBool.
Require Import Crypto.Util.ZRange.
Require Import Crypto.Util.ZRange.Operations.
Require Import Crypto.Util.ZUtil.Definitions.
Require Import Crypto.Util.ZUtil.Notations.
Require Import Crypto.Util.ZUtil.Tactics.LtbToLt.
Require Import Crypto.Util.ZUtil.Tactics.DivModToQuotRem.
Require Import Crypto.Util.ZUtil.Tactics.PullPush.Modulo.
Require Import Crypto.Util.ZUtil.Tactics.RewriteModSmall.
Require Import Crypto.Util.ZUtil.Tactics.ZeroBounds.
Require Import Crypto.Util.ZUtil.Tactics.LinearSubstitute.
Require Import Crypto.Util.ZUtil.Hints.
Require Import Crypto.Util.ZUtil.Hints.Core.
Require Import Crypto.Util.ZUtil.ZSimplify.Core.
Require Import Crypto.Util.ZUtil.ZSimplify.
Require Import Crypto.Util.ZUtil.ZSimplify.Simple.
Require Import Crypto.Util.ZUtil.Definitions.
Require Import Crypto.Util.ZUtil.AddGetCarry.
Require Import Crypto.Util.ZUtil.MulSplit.
Require Import Crypto.Util.ZUtil.TruncatingShiftl.
Require Import Crypto.Util.ZUtil.Zselect.
Require Import Crypto.Util.ZUtil.Div.
Require Import Crypto.Util.ZUtil.Divide.
Require Import Crypto.Util.ZUtil.Modulo.
Require Import Crypto.Util.ZUtil.Pow.
Require Import Crypto.Util.ZUtil.Land.
Require Import Crypto.Util.ZUtil.LandLorShiftBounds.
Require Import Crypto.Util.ZUtil.Shift.
Require Import Crypto.Util.ZRange.
Require Import Crypto.Util.ZRange.Operations.
Require Import Crypto.Util.ZRange.BasicLemmas.
Require Import Crypto.Util.ZRange.OperationsBounds.
Require Import Crypto.Util.Tactics.NormalizeCommutativeIdentifier.
Require Import Crypto.Util.Tactics.BreakMatch.
Require Import Crypto.Util.Tactics.SplitInContext.
Require Import Crypto.Util.Tactics.SpecializeAllWays.
Require Import Crypto.Util.Tactics.SpecializeBy.
Require Import Crypto.Util.Tactics.UniquePose.
Require Import Crypto.Util.Tactics.RewriteHyp.
Require Import Crypto.Util.Tactics.Head.
Require Import Crypto.Util.Tactics.SetEvars.
Require Import Crypto.Util.Tactics.SubstEvars.
Require Import Crypto.Util.Prod.
Require Import Crypto.Util.Bool.
Require Import Crypto.Util.ListUtil.
Require Import Crypto.Util.ListUtil.Forall.
Require Import Crypto.Util.ListUtil.ForallIn.
Require Import Crypto.Util.NatUtil.
Require Import Crypto.Util.Option.
Require Import Crypto.Util.CPSNotations.
Require Import Crypto.Util.HProp.
Require Import Crypto.Util.Decidable.
Require Crypto.Util.PrimitiveProd.
Require Crypto.Util.PrimitiveHList.
Require Import Crypto.Language.PreExtra.
Require Import Crypto.CastLemmas.
Require Import Crypto.Rewriter.Rules.
Require Import Crypto.Util.LetIn.
Require Import Crypto.Util.Tactics.Head.
Require Import Crypto.Util.Notations.
Import ListNotations. Local Open Scope bool_scope. Local Open Scope Z_scope.

Local Definition mymap {A B} := Eval cbv in @List.map A B.
Local Definition myapp {A} := Eval cbv in @List.app A.
Local Definition myflatten {A} := Eval cbv in List.fold_right myapp (@nil A).
Local Notation dont_do_again := (pair false) (only parsing).
Local Notation do_again := (pair true) (only parsing).

Local Ltac start_proof :=
  cbv [snd]; hnf; cbv [id
                         PrimitiveHList.hlist ident.eagerly ident.literal Let_In ident.cast2]; ident.fancy.cbv_fancy;
  repeat apply PrimitiveProd.Primitive.pair; try exact tt.

Local Hint Resolve
      eq_repeat_nat_rect
      eq_app_list_rect
      eq_combine_list_rect
      eq_firstn_nat_rect
      eq_skipn_nat_rect
      eq_update_nth_nat_rect
  : core.

Lemma nbe_rewrite_rules_proofs
  : PrimitiveHList.hlist (@snd bool Prop) nbe_rewrite_rulesT.
Proof using Type. start_proof; auto. Qed.

Definition nbe_rewrite_rules_with_proofs
  := Eval cbv [PrimitiveHList.combine_hlist nbe_rewrite_rulesT] in
      PrimitiveHList.combine_hlist _ nbe_rewrite_rules_proofs.

Local Ltac interp_good_t_step_related :=
  first [ lazymatch goal with
          | [ |- ?x = ?x ] => reflexivity
          | [ |- True ] => exact I
          | [ H : ?x = true, H' : ?x = false |- _ ] => exfalso; clear -H H'; congruence
          | [ |- ?G ] => has_evar G; reflexivity
          (*| [ |- context[_ == _] ] => reflexivity*)
          (*| [ |- context[(fst ?x, snd ?x)] ] => progress eta_expand
                | [ |- context[match ?x with pair a b => _ end] ] => progress eta_expand*)
          end
        | progress cbn [fst snd] in *
        | match goal with
          | [ H : zrange * zrange |- _ ] => destruct H
          end
        | progress intros
        | progress subst
        | assumption
        | progress inversion_option
        | progress destruct_head'_and
        | progress destruct_head'_unit
        | progress split_andb
        | match goal with
          | [ H : ?x = ?x -> _ |- _ ] => specialize (H eq_refl)
          | [ H : forall v : unit, _ |- _ ] => specialize (H tt)
          | [ H : negb ?b = true |- _ ] => rewrite (@Bool.negb_true_iff b) in H
          | [ |- context[Z.mul_split ?a ?b ?c] ]
            => rewrite (surjective_pairing (Z.mul_split a b c)), Z.mul_split_div, Z.mul_split_mod
          | [ |- context[Z.zselect] ] => rewrite Z.zselect_correct
          | [ |- context[Z.truncating_shiftl] ] => rewrite Z.truncating_shiftl_correct
          | [ |- context[Z.sub_get_borrow_full ?a ?b ?c] ]
            => rewrite (surjective_pairing (Z.sub_get_borrow_full a b c)), Z.sub_get_borrow_full_div, Z.sub_get_borrow_full_mod
          | [ |- context[Z.sub_with_get_borrow_full ?a ?b ?c ?d] ]
            => rewrite (surjective_pairing (Z.sub_with_get_borrow_full a b c d)), Z.sub_with_get_borrow_full_div, Z.sub_with_get_borrow_full_mod
          | [ |- context[Z.add_get_carry_full ?a ?b ?c] ]
            => rewrite (surjective_pairing (Z.add_get_carry_full a b c)), Z.add_get_carry_full_div, Z.add_get_carry_full_mod
          | [ |- context[Z.add_with_get_carry_full ?a ?b ?c ?d] ]
            => rewrite (surjective_pairing (Z.add_with_get_carry_full a b c d)), Z.add_with_get_carry_full_div, Z.add_with_get_carry_full_mod
          | [ |- context[Z.mul_high ?a ?b ?c] ]
            => rewrite Z.mul_high_div
          | [ |- pair _ _ = pair _ _ ] => apply f_equal2
          | [ |- ?a mod ?b = ?a' mod ?b ] => apply f_equal2; lia
          | [ |- ?a / ?b = ?a' / ?b ] => apply f_equal2; lia
          | [ |- Z.opp _ = Z.opp _ ] => apply f_equal
          end
        | break_innermost_match_step
        | break_innermost_match_hyps_step
        | progress destruct_head'_or ].

Lemma arith_rewrite_rules_proofs (max_const_val : Z)
  : PrimitiveHList.hlist (@snd bool Prop) (arith_rewrite_rulesT max_const_val).
Proof using Type.
  start_proof; auto; intros; try lia.
  all: autorewrite with zsimplify_const; try reflexivity.
  all: repeat first [ reflexivity
                    | match goal with
                      | [ |- context[Z.shiftl] ] => rewrite Z.shiftl_mul_pow2 by auto with zarith
                      | [ |- context[Z.shiftr] ] => rewrite Z.shiftr_div_pow2 by auto with zarith
                      | [ H : ?x = 2^?n |- context[Z.land _ (?x - 1)] ]
                        => rewrite !Z.sub_1_r, H, <- Z.ones_equiv, Z.land_ones by auto with zarith
                      end
                    | Z.div_mod_to_quot_rem; nia
                    | interp_good_t_step_related ].
Qed.

Local Lemma unfold_is_bounded_by_bool v r
  : is_bounded_by_bool v r = true -> lower r <= v <= upper r.
Proof using Type.
  cbv [is_bounded_by_bool]; intro; split_andb; Z.ltb_to_lt; split; assumption.
Qed.

Local Lemma unfold_is_tighter_than_bool r1 r2
  : is_tighter_than_bool r1 r2 = true -> lower r2 <= lower r1 /\ upper r1 <= upper r2.
Proof using Type.
  cbv [is_tighter_than_bool]; intro; split_andb; Z.ltb_to_lt; split; assumption.
Qed.

Local Ltac interp_good_t_step_arith :=
  first [ lazymatch goal with
          | [ |- ?x = ?x ] => reflexivity
          | [ |- True ] => exact I
          | [ H : ?x = true, H' : ?x = false |- _ ] => exfalso; clear -H H'; congruence
          | [ H : true = false |- _ ]=> exfalso; clear -H; congruence
          | [ H : false = true |- _ ]=> exfalso; clear -H; congruence
          end
        | progress cbv [option_beq] in *
        | match goal with
          | [ H : context[ZRange.normalize (ZRange.normalize _)] |- _ ]
            => rewrite ZRange.normalize_idempotent in H
          | [ |- context[ZRange.normalize (ZRange.normalize _)] ]
            => rewrite ZRange.normalize_idempotent
          | [ |- context[ident.cast (ZRange.normalize ?r)] ]
            => rewrite ident.cast_normalize
          | [ H : context[ident.cast (ZRange.normalize ?r)] |- _ ]
            => rewrite ident.cast_normalize in H
          | [ H : ?T, H' : ?T |- _ ] => clear H'
          | [ H : context[is_bounded_by_bool _ (ZRange.normalize (-_))] |- _ ]
            => rewrite ZRange.is_bounded_by_bool_move_opp_normalize in H
          | [ |- context[is_bounded_by_bool _ (ZRange.normalize (-_))] ]
            => rewrite ZRange.is_bounded_by_bool_move_opp_normalize
          | [ H : is_bounded_by_bool ?v (ZRange.normalize ?r) = true |- context[ident.cast ?r ?v] ]
            => rewrite (@ident.cast_in_normalized_bounds r v) by exact H
          | [ H : is_bounded_by_bool ?v (ZRange.normalize ?r) = true |- context[ident.cast (-?r) (-?v)] ]
            => rewrite (@ident.cast_in_normalized_bounds (-r) (-v));
               [ | clear -H ]
          | [ |- context[ident.cast ?r (-ident.cast (-?r) ?v)] ]
            => rewrite (ident.cast_in_normalized_bounds r (-ident.cast (-r) v))
              by (rewrite <- ZRange.is_bounded_by_bool_move_opp_normalize; apply ident.cast_always_bounded)
          | [ |- context[ident.cast ?r (ident.cast ?r _)] ]
            => rewrite (@ident.cast_idempotent r)
          | [ H : is_bounded_by_bool _ ?r = true |- _]
            => is_var r; unique pose proof (ZRange.is_bounded_by_normalize _ _ H)
          | [ H : lower ?x = upper ?x |- _ ] => is_var x; destruct x; cbn [upper lower] in *
          | [ H : is_bounded_by_bool ?x (ZRange.normalize r[?y~>?y]) = true |- _ ]
            => apply ZRange.is_bounded_by_bool_normalize_constant_iff in H
          | [ H : is_bounded_by_bool ?x r[?y~>?y] = true |- _ ]
            => apply ZRange.is_bounded_by_bool_constant_iff in H
          | [ Hx : is_bounded_by_bool ?x _ = true, Hy : is_bounded_by_bool ?y _ = true
              |- Z.ltz ?x ?y = _ ]
            => cbv [Z.ltz];
               apply unfold_is_bounded_by_bool in Hx;
               apply unfold_is_bounded_by_bool in Hy
          end
        | progress intros
        | progress subst
        | assumption
        | progress destruct_head'_and
        | progress Z.ltb_to_lt
        | progress split_andb
        | match goal with
          | [ |- ?a mod ?b = ?a' mod ?b ] => apply f_equal2; lia
          | [ |- ?a / ?b = ?a' / ?b ] => apply f_equal2; lia
          | [ |- Z.opp _ = Z.opp _ ] => apply f_equal
          end
        | break_innermost_match_step
        | break_innermost_match_hyps_step
        | progress destruct_head'_or
        | match goal with
          | [ |- context[-ident.cast (-?r) (-?v)] ] => rewrite (ident.cast_opp' r v)
          | [ |- context[ident.cast ?r ?v] ]
            => is_var v;
               pose proof (@ident.cast_always_bounded r v);
               generalize dependent (ident.cast r v); clear v; intro v; intros
          | [ |- context[ident.cast ?r ?v] ]
            => is_var v;
               pose proof (@ident.cast_cases r v);
               generalize dependent (ident.cast r v); intros
          | [ H : is_bounded_by_bool ?v ?r = true, H' : is_tighter_than_bool ?r ?r' = true |- _ ]
            => unique assert (is_bounded_by_bool v r' = true) by (eauto 2 using ZRange.is_bounded_by_of_is_tighter_than)
          | [ H : is_bounded_by_bool (-?v) ?r = true, H' : (-?r <=? ?r')%zrange = true |- _ ]
            => unique assert (is_bounded_by_bool v r' = true)
              by (apply (@ZRange.is_bounded_by_of_is_tighter_than _ _ H');
                  rewrite <- ZRange.is_bounded_by_bool_opp, ZRange.opp_involutive; exact H)
          | [ H : is_bounded_by_bool ?v (-?r) = true |- _ ]
            => is_var v;
               unique assert (is_bounded_by_bool (-v) r = true)
                 by now rewrite <- ZRange.is_bounded_by_bool_move_opp_normalize, ZRange.normalize_opp
          | [ H : is_bounded_by_bool ?x r[0~>?v-1] = true |- _ ]
            => progress (try unique assert (0 <= x); try unique assert (x <= v - 1));
               [ clear -H; cbv [is_bounded_by_bool] in H; cbn [lower upper] in H; Bool.split_andb; Z.ltb_to_lt; lia..
               | ]
          end
        | match goal with
          | [ |- context[Z.shiftl] ] => rewrite Z.shiftl_mul_pow2 by auto with zarith
          | [ |- context[Z.shiftr] ] => rewrite Z.shiftr_div_pow2 by auto with zarith
          | [ |- context[Z.shiftl _ (-_)] ] => rewrite Z.shiftl_opp_r
          | [ |- context[Z.land _ (Z.ones _)] ] => rewrite Z.land_ones by auto using Z.log2_nonneg
          | [ |- context[- - _] ] => rewrite Z.opp_involutive
          | [ H : ?x = 2^Z.log2 ?x |- context[2^Z.log2 ?x] ] => rewrite <- H
          | [ H : ?x = 2^?n |- context[Z.land _ (?x - 1)] ]
            => rewrite !Z.sub_1_r, H, <- Z.ones_equiv, Z.land_ones by auto with zarith
          | [ |- _ = _ :> BinInt.Z ] => progress normalize_commutative_identifier Z.land Z.land_comm
          | [ H : ?x = ?y, H' : ?x <> ?y |- _ ] => exfalso; apply H', H
          | [ H : ?x = 2^Z.log2_up ?x - 1 |- context[2^Z.log2_up ?x - 1] ] => rewrite <- H
          | [ H : ?x = 2^Z.log2 ?x, H' : context[2^Z.log2 ?x] |- _ = _ :> BinInt.Z ]
            => rewrite <- H in H'
          | [ |- _ = _ :> BinInt.Z ] => progress autorewrite with zsimplify_const
          | [ H : 0 <= ?x, H' : ?x <= ?r - 1 |- context[?x mod ?r] ]
            => rewrite (Z.mod_small x r) by (clear -H H'; lia)
          | [ H : 0 <= ?x, H' : ?x <= ?y - 1 |- context[?x / ?y] ]
            => rewrite (Z.div_small x y) by (clear -H H'; lia)
          | [ H : ?x = 2^Z.log2 ?x |- _ ]
            => unique assert (0 <= x) by (rewrite H; auto with zarith)
          | [ |- _ mod ?x = _ mod ?x ]
            => progress (push_Zmod; pull_Zmod)
          | [ |- ?f (_ mod ?x) = ?f (_ mod ?x) ]
            => progress (push_Zmod; pull_Zmod)
          | [ |- _ mod ?x = _ mod ?x ]
            => apply f_equal2; (lia + nia)
          | _ => rewrite !Z.shiftl_mul_pow2 in * by auto using Z.log2_nonneg
          | _ => rewrite !Z.land_ones in * by auto using Z.log2_nonneg
          | H : ?x mod ?b * ?y <= _
            |- context [ (?x * ?y) mod ?b ] =>
            rewrite (PullPush.Z.mul_mod_l x y b);
            rewrite (Z.mod_small (x mod b * y) b) by omega
          | [ |- context[_ - ?x + ?x] ] => rewrite !Z.sub_add
          | [ |- context[_ mod (2^_) * 2^_] ] => rewrite <- !Z.mul_mod_distr_r_full
          | [ |- context[Z.land _ (Z.ones _)] ] => rewrite !Z.land_ones by lia
          | [ |- context[2^?a * 2^?b] ] => rewrite <- !Z.pow_add_r by lia
          | [ |- context[-?x + ?y] ] => rewrite !Z.add_opp_l
          | [ |- context[?n + - ?m] ] => rewrite !Z.add_opp_r
          | [ |- context[?n - - ?m] ] => rewrite !Z.sub_opp_r
          | [ |- context[Zpos ?p * ?x / Zpos ?p] ]
            => rewrite (@Z.div_mul' x (Zpos p)) in * by (clear; lia)
          | [ H : context[Zpos ?p * ?x / Zpos ?p] |- _ ]
            => rewrite (@Z.div_mul' x (Zpos p)) in * by (clear; lia)
          | [ |- ?f (?a mod ?r) = ?f (?b mod ?r) ] => apply f_equal; apply f_equal2; lia
          | [ |- context[-?a - ?b + ?c] ] => replace (-a - b + c) with (c - a - b) by (clear; lia)
          | [ |- context[?x - ?y + ?z] ]
            => lazymatch goal with
               | [ |- context[z - y + x] ]
                 => progress replace (z - y + x) with (x - y + z) by (clear; lia)
               end
          | [ |- context[?x - ?y - ?z] ]
            => lazymatch goal with
               | [ |- context[x - z - y] ]
                 => progress replace (x - z - y) with (x - y - z) by (clear; lia)
               end
          | [ |- context[?x + ?y] ]
            => lazymatch goal with
               | [ |- context[y + x] ]
                 => progress replace (y + x) with (x + y) by (clear; lia)
               end
          | [ |- context[?x + ?y + ?z] ]
            => lazymatch goal with
               | [ |- context[x + z + y] ]
                 => progress replace (x + z + y) with (x + y + z) by (clear; lia)
               | [ |- context[z + x + y] ]
                 => progress replace (z + x + y) with (x + y + z) by (clear; lia)
               | [ |- context[z + y + x] ]
                 => progress replace (z + y + x) with (x + y + z) by (clear; lia)
               | [ |- context[y + x + z] ]
                 => progress replace (y + x + z) with (x + y + z) by (clear; lia)
               | [ |- context[y + z + x] ]
                 => progress replace (y + z + x) with (x + y + z) by (clear; lia)
               end
          | [ |- - ident.cast (-?r) (- (?x / ?y)) = ident.cast ?r (?x' / ?y) ]
            => tryif constr_eq x x' then fail else replace x with x' by lia
          | [ |- _ = _ :> BinInt.Z ] => progress autorewrite with zsimplify_fast
          end ].

Local Ltac remove_casts :=
  repeat match goal with
         | [ |- context[ident.cast r[?x~>?x] ?x] ]
           => rewrite (ident.cast_in_bounds r[x~>x] x) by apply ZRange.is_bounded_by_bool_constant
         | [ |- context[ident.cast ?r (ident.cast ?r _)] ]
           => rewrite ident.cast_idempotent
         | [ H : context[ident.cast ?r (ident.cast ?r _)] |- _ ]
           => rewrite ident.cast_idempotent in H
         | [ |- context[ident.cast ?r ?v] ]
           => is_var v;
              pose proof (@ident.cast_always_bounded r v);
              generalize dependent (ident.cast r v);
              clear v; intro v; intros
         | [ H : context[ident.cast ?r ?v] |- _ ]
           => is_var v;
              pose proof (@ident.cast_always_bounded r v);
              generalize dependent (ident.cast r v);
              clear v; intro v; intros
         | [ H : context[ZRange.constant ?v] |- _ ] => unique pose proof (ZRange.is_bounded_by_bool_normalize_constant v)
         | [ H : is_tighter_than_bool (?ZRf ?r1 ?r2) (ZRange.normalize ?rs) = true,
                 H1 : is_bounded_by_bool ?v1 ?r1 = true,
                      H2 : is_bounded_by_bool ?v2 ?r2 = true
             |- _ ]
           => let cst := multimatch goal with
                         | [ |- context[ident.cast rs (?Zf v1 v2)] ] => constr:(ident.cast rs (Zf v1 v2))
                         | [ H : context[ident.cast rs (?Zf v1 v2)] |- _ ] => constr:(ident.cast rs (Zf v1 v2))
                         end in
              lazymatch cst with
              | ident.cast rs (?Zf v1 v2)
                => let lem := lazymatch constr:((ZRf, Zf)%core) with
                              | (ZRange.shiftl, Z.shiftl)%core => constr:(@ZRange.is_bounded_by_bool_shiftl v1 r1 v2 r2 H1 H2)
                              | (ZRange.shiftr, Z.shiftr)%core => constr:(@ZRange.is_bounded_by_bool_shiftr v1 r1 v2 r2 H1 H2)
                              | (ZRange.land, Z.land)%core => constr:(@ZRange.is_bounded_by_bool_land v1 r1 v2 r2 H1 H2)
                              end in
                   try unique pose proof (@ZRange.is_bounded_by_of_is_tighter_than _ _ H _ lem);
                   clear H;
                   rewrite (@ident.cast_in_normalized_bounds rs (Zf v1 v2)) in * by assumption
              end
         | [ H : is_tighter_than_bool (?ZRf ?r1) (ZRange.normalize ?rs) = true,
                 H1 : is_bounded_by_bool ?v1 ?r1 = true
             |- _ ]
           => let cst := multimatch goal with
                         | [ |- context[ident.cast rs (?Zf v1)] ] => constr:(ident.cast rs (Zf v1))
                         | [ H : context[ident.cast rs (?Zf v1)] |- _ ] => constr:(ident.cast rs (Zf v1))
                         end in
              lazymatch cst with
              | ident.cast rs (?Zf v1)
                => let lem := lazymatch constr:((ZRf, Zf)%core) with
                              | (ZRange.cc_m ?s, Z.cc_m ?s)%core => constr:(@ZRange.is_bounded_by_bool_cc_m s v1 r1 H1)
                              end in
                   try unique pose proof (@ZRange.is_bounded_by_of_is_tighter_than _ _ H _ lem);
                   clear H;
                   rewrite (@ident.cast_in_normalized_bounds rs (Zf v1)) in * by assumption
              end
         | [ H : is_bounded_by_bool ?v (ZRange.normalize ?r) = true |- context[ident.cast ?r ?v] ]
           => rewrite (@ident.cast_in_normalized_bounds r v) in * by assumption
         | [ H : is_bounded_by_bool ?v (ZRange.normalize ?r) = true, H' : context[ident.cast ?r ?v] |- _ ]
           => rewrite (@ident.cast_in_normalized_bounds r v) in * by assumption
         | [ H : is_bounded_by_bool ?v ?r = true,
                 H' : is_tighter_than_bool ?r r[0~>?x-1]%zrange = true,
                      H'' : Z.eqb ?x ?m = true
             |- context[?v mod ?m] ]
           => unique assert (is_bounded_by_bool v r[0~>x-1] = true)
             by (eapply ZRange.is_bounded_by_of_is_tighter_than; eassumption)
         | _ => progress Z.ltb_to_lt
         | _ => progress subst
         end.

Local Ltac unfold_cast_lemmas :=
  repeat match goal with
         | [ H : context[ZRange.normalize (ZRange.constant _)] |- _ ]
           => rewrite ZRange.normalize_constant in H
         | [ H : is_bounded_by_bool _ (ZRange.normalize ?r) = true |- _ ]
           => is_var r; generalize dependent (ZRange.normalize r); clear r; intro r; intros
         | [ H : is_bounded_by_bool _ (ZRange.normalize r[0 ~> 2 ^ _ - 1]) = true |- _ ]
           => rewrite ZRange.normalize_id_pow2 in H by lia
         | [ H : is_bounded_by_bool ?x (ZRange.constant ?x) = true |- _ ]
           => clear H
         | [ H : is_bounded_by_bool ?x ?r = true |- _ ]
           => is_var r; apply unfold_is_bounded_by_bool in H
         | [ H : is_bounded_by_bool ?x r[_~>_] = true |- _ ]
           => apply unfold_is_bounded_by_bool in H
         | [ H : is_tighter_than_bool r[_~>_] r[_~>_] = true |- _ ]
           => apply unfold_is_tighter_than_bool in H
         | _ => progress cbn [lower upper] in *
         | [ H : context[lower ?r] |- _ ]
           => is_var r; let l := fresh "l" in let u := fresh "u" in destruct r as [l u]
         | [ H : context[upper ?r] |- _ ]
           => is_var r; let l := fresh "l" in let u := fresh "u" in destruct r as [l u]
         | _ => progress Z.ltb_to_lt
         end.

Local Ltac clear_useless_hyps :=
  repeat match goal with
         | [ H : True |- _ ] => clear H
         | [ H : unit |- _ ] => clear H
         | [ H : nat |- _ ] => clear H
         | [ H : Z |- _ ] => clear H
         | [ H : zrange |- _ ] => clear H
         | [ H : ?x = ?x |- _ ] => clear H
         | [ H : ?x <= ?y <= ?z |- _ ]
           => is_var x; is_var z; clear x z H
         | [ H : ?x <= ?x' /\ ?y' <= ?y, H' : ?x' <= ?z <= ?y' |- _ ]
           => is_var x'; is_var y';
              let H'' := fresh in
              assert (H'' : x <= z <= y) by (clear -H H'; lia);
              clear x' y' H H'
         end.

Local Ltac systematically_handle_casts :=
  remove_casts; unfold_cast_lemmas; clear_useless_hyps.


Local Ltac fin_with_nia :=
  lazymatch goal with
  | [ |- ident.cast ?r _ = ident.cast ?r _ ] => apply f_equal; Z.div_mod_to_quot_rem; nia
  | _ => reflexivity || (Z.div_mod_to_quot_rem; (lia + nia))
  end.

Local Ltac do_clear_nia x y r H H' :=
  let rec find_H x :=
      lazymatch goal with
      | [ H : _ <= x < _ |- _ ] => H
      | [ H : _ <= x <= _ |- _ ] => H
      | _ => lazymatch x with
             | ?x0 + ?x1
               => let H0 := find_H x0 in
                  let H1 := find_H x1 in
                  let m0 := lazymatch type of H0 with 0 <= _ <= ?m => m end in
                  let m1 := lazymatch type of H1 with 0 <= _ <= ?m => m end in
                  let H := fresh in
                  let __ := lazymatch goal with
                            | _ => assert (H : 0 <= x <= m0 + m1) by (clear -H0 H1; lia)
                            end in
                  H
             | ?x0 - ?x1
               => let H0 := find_H x0 in
                  let H1 := find_H x1 in
                  let m0 := lazymatch type of H0 with 0 <= _ <= ?m => m end in
                  let m1 := lazymatch type of H1 with 0 <= _ <= ?m => m end in
                  let H := fresh in
                  let __ := lazymatch goal with
                            | _ => assert (H : -m1 <= x <= m0) by (clear -H0 H1; lia)
                            end in
                  H
             end
      end in
  idtac;
  let Hx := find_H x in
  let Hy := find_H y in
  lazymatch goal with
  | [ Hm : 0 < 2^_ <= 2^_, Hr : 0 <= r < _ |- _ ]
    => clear -Hx Hy Hm Hr H' H; nia
  end.

Lemma arith_with_casts_rewrite_rules_proofs
  : PrimitiveHList.hlist (@snd bool Prop) arith_with_casts_rewrite_rulesT.
Proof using Type.
  start_proof; auto; intros; try lia.
  all: repeat interp_good_t_step_related.
  all: repeat interp_good_t_step_arith.
  all: remove_casts; try fin_with_nia.
Qed.

Lemma strip_literal_casts_rewrite_rules_proofs
  : PrimitiveHList.hlist (@snd bool Prop) strip_literal_casts_rewrite_rulesT.
Proof using Type.
  start_proof; auto; intros; remove_casts; reflexivity.
Qed.

Section fancy.
  Context (invert_low invert_high : Z (*log2wordmax*) -> Z -> option Z)
          (value_range flag_range : zrange).

  Lemma fancy_rewrite_rules_proofs
    : PrimitiveHList.hlist (@snd bool Prop) fancy_rewrite_rulesT.
  Proof using Type. start_proof. Qed.

  Local Ltac fancy_local_t :=
    repeat match goal with
           | [ H : forall s v v', ?invert_low s v = Some v' -> v = _,
                 H' : ?invert_low _ _ = Some _ |- _ ] => apply H in H'
           | [ H : forall s v v', ?invert_low s v = Some v' -> v = _ |- _ ]
             => clear invert_low H
           | [ H : None <> None |- _ ] => exfalso; exact (H eq_refl)
           end.
  Local Ltac more_fancy_arith_t := repeat autorewrite with zsimplify in *.

  Lemma fancy_with_casts_rewrite_rules_proofs
        (Hlow : forall s v v', invert_low s v = Some v' -> v = Z.land v' (2^(s/2)-1))
        (Hhigh : forall s v v', invert_high s v = Some v' -> v = Z.shiftr v' (s/2))
    : PrimitiveHList.hlist (@snd bool Prop) (@fancy_with_casts_rewrite_rulesT invert_low invert_high value_range flag_range).
  Proof using Type.
    start_proof; auto; intros; try lia.
    Time all: repeat interp_good_t_step_related.
    Time all: fancy_local_t.
    Time all: try solve [ systematically_handle_casts; repeat interp_good_t_step_arith ].
  Qed.
End fancy.

Local Ltac cast_to_arith r v :=
  match goal with
  | [ |- context[ident.cast r v] ]
    => let H := fresh in
       eassert (H : _);
       [ | rewrite (ident.cast_in_bounds r v) by exact H ]
  end;
  repeat
    first [ match goal with
            | [ |- context[andb _ _ = true] ] => rewrite Bool.andb_true_iff
            | [ |- and _ _ ] => split
            end
          | progress unfold is_bounded_by_bool in *
          | progress cbn [lower upper] in *
          | progress Bool.split_andb
          | progress Z.ltb_to_lt ].

Lemma to_double_bounds xl xh bitwidth :
  0 <= xl <= 2 ^ bitwidth - 1 ->
  0 <= xh <= 2 ^ bitwidth - 1 ->
  xl + xh * 2 ^ bitwidth <= 2 ^ bitwidth * 2 ^ bitwidth - 1.
Proof. nia. Qed.

Local Ltac pose_mod_bounds :=
  repeat match goal with
         | |- context [?a mod ?b] =>
           unique pose proof (Z.mod_pos_bound a b ltac:(auto with zarith))
         end.

Local Ltac pose_shiftr_bounds :=
  repeat match goal with
         | |- context [?a >> ?b] =>
           unique pose proof
                  (Z.shiftr_nonneg_le
                     a b ltac:(auto with zarith) ltac:(auto with zarith));
           unique pose proof (proj2 (Z.shiftr_nonneg a b) ltac:(auto with zarith))
         end.

Local Ltac bounds_arith_hammer :=
  try match goal with
      | [ H0 : 0 < ?z, H : 0 <= ?x <= ?z - 1, H' : 0 <= ?y <= ?z - 1 |- ?x * ?y / ?z <= ?z - 1 ]
        => clear -H H' H0 (* fast path so we don't time out on 8.9 *)
      end;
  repeat match goal with
         | _ => progress pose_mod_bounds
         | _ => progress pose_shiftr_bounds
         | |- _ / _ <= _ - 1 =>
           apply Le.Z.le_sub_1_iff;
           apply Z.div_lt_upper_bound; solve [auto with zarith nia]
         | _ => apply to_double_bounds; lia
         | _ => solve [Z.zero_bounds]
         | _ => lia
         end.

(* TODO: can this be replaced by just adding Z.shiftr_range to zarith? *)
Local Ltac use_shiftr_range :=
  try split; Z.zero_bounds; apply Z.shiftr_range;
  autorewrite with zsimplify; auto with zarith.

Lemma mul_split_rewrite_rules_proofs (bitwidth : Z) (lgcarrymax : Z)
  : PrimitiveHList.hlist (@snd bool Prop) (mul_split_rewrite_rulesT bitwidth lgcarrymax).
Proof using Type.
  start_proof; auto; intros; try lia.
  (* assert bounds to help out [lia] *)
  all: try (assert (0 < 2 ^ bitwidth) by Z.zero_bounds;
            assert (0 < 2 ^ bitwidth * 2 ^ bitwidth) by Z.zero_bounds;
            assert ((2 ^ bitwidth - 1) * (2 ^ bitwidth - 1) <= 2 ^ bitwidth * 2 ^ bitwidth - 1) as Hle_double
                by (autorewrite with push_Zmul zsimplify; lia)).
  all: try (assert (2 <= 2 ^ lgcarrymax) by auto with zarith).
  all: try (assert (0 <= bitwidth) by (apply Z.nonneg_pow_pos with (a:=2); lia)).
  all: try (assert (bitwidth < 2 ^ bitwidth) by (apply Z.pow_gt_lin_r; lia)).
  all: repeat interp_good_t_step_related.
  all: systematically_handle_casts.
  all: try reflexivity.
  all:unfold Z.combine_at_bitwidth.
  all:rewrite ?Z.shiftl_mul_pow2, ?Z.shiftr_div_pow2, ?Z.pow_twice_r in * by lia.

  (* special case to match on a particular rule that is way easier to prove this
     way; this is hacky and should ideally be removed eventually *)
  all: try match goal with
           | |- ident.cast r[0 ~> 2 ^ ?b * 2 ^ ?b - 1] (_ >> _) = _ =>
             f_equal
           end.

  (* remove whatever bounds [bounds_arith_hammer] solves *)
  all:repeat match goal with
             | [ |- context[ident.cast ?r ?v] ]
               => cast_to_arith r v; [ solve [bounds_arith_hammer] .. | ]
             end.

  (* change the rest of the casts to mods *)
  all:rewrite ?ident.platform_specific_cast_0_is_mod by lia;
    autorewrite with zsimplify_fast; Z.rewrite_mod_small.

  all:
    repeat match goal with
           | |- context [(_ * _) mod _] =>
             (* multiplication case *)
             rewrite Z.mul_div_eq' by lia; lia
           | |- ((_ + _) * ?y) mod _ = _ =>
             (* double * single multiplication case *)
             rewrite Z.mul_add_distr_r, <- Z.mul_assoc, (Z.mul_comm (2^_) y), Z.mul_assoc
           | |- (_ + _) mod (_ * _) = _ =>
             (* addition cases *)
             rewrite !Z.rem_mul_r by lia;
               push_Zmod; pull_Zmod; autorewrite with zsimplify;
                 solve [repeat (ring_simplify; f_equal; try lia)]
           | |- (?m &' (_ + _)) mod _ = _ =>
             (* and-addition case *)
             rewrite !(Z.land_comm m)
           | |- ((_ + _) &' _) mod _ = _ =>
             (* addition-and case *)
             rewrite Z.land_add_high by (try apply Z.log2_lt_pow2; lia); lia
           | |- (_ + _) >> _ mod _ = _ =>
             (* take only high bits *)
             rewrite ?Z.shiftr_div_pow2 by lia; autorewrite with zsimplify; lia
           | |- (_ + _) / _ = _ =>
             (* take only high bits *)
             autorewrite with zsimplify; lia
           end.

  (* should have only Z.lor cases now *)
  all:rewrite <-?Z.pow_twice_r,<-?Z.land_ones, <-?Z.shiftl_mul_pow2 in * by lia.
  all:match goal with
      | |- context [Z.lor (?a >> ?b) (_ &' Z.ones ?c)] =>
        rewrite <-(Z.mod_small (a >> b) (2 ^ c)) by auto with zarith;
          rewrite <-Z.land_ones, <-Z.land_lor_distr_l by auto with zarith
      end.
  all:rewrite Z.lor_shiftl by use_shiftr_range.
  all:rewrite Z.shiftr_add_shiftl_low by lia.
  all:match goal with
      | H : ?x < ?y |- context [Z.shiftr ?a (?x - ?y)] =>
        replace (Z.shiftr a (x - y)) with (Z.shiftl a (y - x))
          by (rewrite <-Z.shiftl_opp_r; f_equal; lia)
      end.
  all:try reflexivity.

  all:rewrite ?Z.land_ones, Z.mod_eq by auto with zarith.
  all:rewrite ?(Z.mul_comm (2 ^ _)), <-?Z.shiftl_mul_pow2, <-?Z.shiftr_div_pow2 by auto with zarith.
  all:rewrite Z.shiftr_add_shiftl_high by use_shiftr_range.
  all:autorewrite with zsimplify; lia.
Qed.

(* TODO: move *)
Lemma Z_mod_pow_same_base_larger a b n m :
  0 <= n < m -> 0 < b ->
  (a mod (b^n)) mod (b^m) = a mod b^n.
Proof.
  intros.
  pose proof Z.mod_pos_bound a (b^n) ltac:(auto with zarith).
  assert (b^n <= b^m) by auto with zarith.
  apply Z.mod_small. auto with zarith.
Qed.

(* TODO: move *)
Lemma Z_mod_pow_same_base_smaller a b n m :
  0 <= m < n -> 0 < b ->
  (a mod (b^n)) mod (b^m) = a mod b^m.
Proof.
  intros.
  replace n with (m+(n-m)) by lia.
  rewrite Z.pow_add_r by lia.
  rewrite Z.rem_mul_r by auto with zarith.
  push_Zmod; pull_Zmod.
  autorewrite with zsimplify_fast; reflexivity.
Qed.

Lemma multiret_split_rewrite_rules_proofs (bitwidth : Z) (lgcarrymax : Z)
  : PrimitiveHList.hlist (@snd bool Prop) (multiret_split_rewrite_rulesT bitwidth lgcarrymax).
Proof using Type.
  assert (0 <= lgcarrymax <= bitwidth -> 0 < 2^lgcarrymax <= 2^bitwidth) by auto with zarith.

  start_proof; auto; intros; try lia.
  all: repeat interp_good_t_step_related.
  all: systematically_handle_casts; try reflexivity.
  all: rewrite !ident.platform_specific_cast_0_is_mod, ?Z.sub_add, ?Z.mod_mod by lia; try reflexivity.
  all:
    try
      (match goal with
      | |- context [Z.land ?x (2^?n - 1)] =>
        replace (2^n-1) with (Z.ones n) by
            (rewrite Z.sub_1_r, <-Z.ones_equiv; reflexivity);
          rewrite !Z.land_ones by lia
       end).
  all: rewrite ?Z.shiftr_div_pow2, ?Z.shiftl_mul_pow2 by lia.
  all: rewrite ?Z_mod_pow_same_base_larger,
       ?Z_mod_pow_same_base_smaller by lia.
  all: try reflexivity.
  all: push_Zmod; pull_Zmod; try reflexivity.
  all: progress specialize_by auto.
  all: try solve[
  lazymatch goal with
       | [ |- ?x mod ?y = _ mod ?y ]
         => apply f_equal2; [ | reflexivity ];
              cbv [Z.ltz]; break_innermost_match; Z.ltb_to_lt; Z.div_mod_to_quot_rem
       end;
   repeat match goal with
              | [ H : ?x + ?y = ?d * ?q + ?r, H' : ?r < ?y |- _ ]
                => is_var q; unique assert (q = 1) by do_clear_nia x y r H H'; subst
              | [ H : ?x + ?y = ?d * ?q + ?r, H' : ?r >= ?y |- _ ]
                => is_var q; unique assert (q = 0) by do_clear_nia x y r H H'; subst
              | [ H : ?x - ?y = ?d * ?q + ?r, H' : ?x < ?r |- _ ]
                => is_var q; unique assert (q = -1) by do_clear_nia x y r H H'; subst
              | [ H : ?x - ?y = ?d * ?q + ?r, H' : ?x >= ?r |- _ ]
                => is_var q; unique assert (q = 0) by do_clear_nia x y r H H'; subst
              | [ H0 : ?x = ?d * ?q0 + ?r0, H : ?x - ?y = ?d * ?q + ?r, H' : ?r0 < ?r |- _ ]
                => (* ugh, this is kind-of complicated; we could just let [nia] handle it, but it runs out of memory on 8.9 *)
                let x' := fresh "x" in
                (remember x as x' eqn:?);
                  symmetry in H0; destruct H0;
                    assert (r0 - y = d * (q - q0) + r) by (clear -H; nia); clear H;
                      let q' := fresh "q" in
                      remember (q - q0) as q' eqn:?; (tryif is_var q then Z.linear_substitute q else idtac)
              | _ => nia
          end].
  { (* TODO : long and manual; fix *)
    push_Zmod; pull_Zmod.
    Z.rewrite_mod_small.
    rewrite <-Z.add_mul_mod by
        (rewrite <-?Z.add_div_ltz_1 by lia;
         try split; auto with zarith; rewrite Z.pow_sub_r by lia;
         apply Z.div_lt_upper_bound; auto with zarith;
         rewrite Z.mul_div_eq, Z.mod_same_pow by auto with zarith;
         autorewrite with zsimplify_fast; auto with zarith).
    rewrite <-Z.div_add by auto with zarith.
    match goal with
      |- context [?x * 2 ^ (?y - ?z) * 2^?z] =>
      replace (x * 2^(y-z) * 2^z) with (x * 2^y);
        [ | transitivity (x * (2^(y-z) * 2^z)); [ | lia];
            rewrite <-Z.pow_add_r by lia; repeat (f_equal; try lia) ]
    end.
    rewrite <-Z.add_div_ltz_1, <-Z.div_mod''', <-!Z.pow_add_r
      by auto with zarith.

    match goal with
    | H : 0 <= ?x <= 2^?y-1, H' : 0 <= ?z <= 2^?y-1 |-
      context [?x + ?z] =>
      let P := fresh "H" in
      assert (0 <= x + z < 2^y + 2^y) as P by auto with zarith;
        rewrite Z.add_diag, Z.pow_mul_base in P by lia
    end.
    assert (2 ^ (bitwidth+1) <= 2 ^ (n+lgcarrymax))
        by auto with zarith.
    match goal with
    | |- context[(?x / ?y) mod ?z] =>
      assert (0 <= x / y < z)
        by (split; auto with zarith;
            apply Z.div_lt_upper_bound; auto with zarith;
            rewrite <-Z.pow_add_r by lia; auto with zarith)
    end.
    match goal with
    | |- context[_ mod (2 ^ (?x + ?y))] =>
      assert (2^x < 2^(x+y)) by auto with zarith
    end.
    Z.rewrite_mod_small.
    reflexivity. }
Qed.
