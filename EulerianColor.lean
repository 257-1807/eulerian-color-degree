module

public import Mathlib.Combinatorics.SimpleGraph.Coloring.Vertex
public import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected
public import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Tactic

@[expose] public section

namespace EulerianColor

open SimpleGraph

/-- Arithmetic mean of the vertex degrees. -/
def averageDegree {V : Type*} [Fintype V] (G : SimpleGraph V) [DecidableRel G.Adj] : ℚ :=
  ((∑ v, G.degree v : ℕ) : ℚ) / Fintype.card V

/-- Eulerian in the original simple-undirected-graph convention. -/
def IsEulerian {V : Type*} [Fintype V] (G : SimpleGraph V) [DecidableRel G.Adj] : Prop :=
  G.Connected ∧ ∀ v, Even (G.degree v)

/-- The clique on 0,...,4 and the cycle 0,5,6,7,8,9,0 share vertex 0. -/
def forwardEdge (i j : Fin 10) : Prop :=
  (i < j ∧ j < 5) ∨ (i = 0 ∧ (j = 5 ∨ j = 9)) ∨
    (5 ≤ i ∧ j.val = i.val + 1)

instance : DecidableRel forwardEdge := fun i j =>
  inferInstanceAs (Decidable ((i < j ∧ j < 5) ∨ (i = 0 ∧ (j = 5 ∨ j = 9)) ∨
    (5 ≤ i ∧ j.val = i.val + 1)))

def witness : SimpleGraph (Fin 10) := SimpleGraph.fromRel forwardEdge

instance : DecidableRel witness.Adj := inferInstanceAs (DecidableRel (SimpleGraph.fromRel forwardEdge).Adj)

theorem witness_eulerian : IsEulerian witness := by
  constructor
  · apply witness.connected_iff_exists_forall_reachable.mpr
    refine ⟨0, ?_⟩
    have r5 : witness.Reachable 0 5 := (show witness.Adj 0 5 by decide).reachable
    have r6 := r5.trans (show witness.Adj 5 6 by decide).reachable
    have r7 := r6.trans (show witness.Adj 6 7 by decide).reachable
    have r8 := r7.trans (show witness.Adj 7 8 by decide).reachable
    intro v
    fin_cases v <;> first | exact Reachable.refl _ | exact r6 | exact r7 | exact r8 |
      exact (show witness.Adj 0 _ by decide).reachable
  · decide

theorem witness_average : averageDegree witness = 16 / 5 := by
  have hs : ∑ v, witness.degree v = 32 := by decide +kernel
  norm_num [averageDegree, hs]

private def coloring (i : Fin 10) : Fin 5 :=
  if h : i.val < 5 then ⟨i.val, h⟩ else if i.val % 2 = 1 then 1 else 2

/-- The five clique vertices need distinct colors, and the attached cycle uses colors 0,1,2. -/
theorem witness_chromatic : witness.chromaticNumber = 5 := by
  change witness.chromaticNumber = (4 : ℕ) + 1
  apply chromaticNumber_eq_iff_colorable_not_colorable.mpr
  constructor
  · exact ⟨Coloring.mk coloring (by decide)⟩
  · rintro ⟨c⟩
    let f : Fin 5 → Fin 10 := Fin.castLE (by decide)
    have hc : Pairwise fun i j => witness.Adj (f i) (f j) := by
      unfold Pairwise
      decide
    have hcard := Fintype.card_le_of_injective _ (c.injective_comp_of_pairwise_adj f hc)
    norm_num at hcard

/-- Literal negation of the universal bound on finite nontrivial Eulerian simple graphs. -/
theorem refute_0caab573 :
    ¬ (∀ (V : Type) [Fintype V] (G : SimpleGraph V) [DecidableRel G.Adj],
      2 ≤ Fintype.card V → IsEulerian G →
        (G.chromaticNumber.toNat : ℚ) ≤ (3 / 2 : ℚ) * averageDegree G) := by
  intro hall
  have h := hall (Fin 10) witness (by decide) witness_eulerian
  rw [witness_chromatic, witness_average] at h
  norm_num at h

/-- A clique on r vertices, with t distinct four-cycles sharing its vertex 0.
The three added vertices of each cycle have labels 0, 1, 2 in path order. -/
abbrev FamilyVertex (r t : ℕ) := Fin r ⊕ (Fin t × Fin 3)

def familyAdj {r t : ℕ} : FamilyVertex r t → FamilyVertex r t → Prop
  | .inl i, .inl j => i ≠ j
  | .inl i, .inr (_, b) | .inr (_, b), .inl i => i.val = 0 ∧ b ≠ 1
  | .inr (a, b), .inr (c, d) =>
      a = c ∧ ((b = 1 ∧ d ≠ 1) ∨ (b ≠ 1 ∧ d = 1))

instance (r t : ℕ) : DecidableRel (@familyAdj r t) := by
  rintro (i | ⟨i,b⟩) (j | ⟨j,d⟩) <;> dsimp [familyAdj] <;> infer_instance

def family (r t : ℕ) : SimpleGraph (FamilyVertex r t) where
  Adj := familyAdj
  symm := ⟨by
    rintro (i | ⟨i,b⟩) (j | ⟨j,d⟩) <;> dsimp [familyAdj] <;> aesop⟩
  loopless := ⟨by rintro (i | ⟨i,b⟩) <;> simp [familyAdj]⟩

instance (r t : ℕ) : DecidableRel (family r t).Adj := inferInstanceAs (DecidableRel familyAdj)

private theorem degree_as_sum {r t : ℕ} (v : FamilyVertex r t) :
    (family r t).degree v = ∑ w, if (family r t).Adj v w then 1 else 0 := by
  rw [Finset.sum_boole, ← (family r t).card_neighborFinset_eq_degree]
  congr 1
  ext w
  simp

theorem clique_degree {r t : ℕ} (i : Fin r) :
    (family r t).degree (.inl i) = r - 1 + (if i.val = 0 then 2*t else 0) := by
  rw [degree_as_sum, Fintype.sum_sum_type]
  simp only [family, familyAdj]
  rw [Fintype.sum_prod_type]
  simp only [Fin.sum_univ_three]
  have hx : (∑ j : Fin r, if i ≠ j then 1 else 0) = r - 1 := by
    rw [Finset.sum_boole]
    have hset : (Finset.univ.filter fun j => i ≠ j) = Finset.univ.erase i := by
      ext j
      simp [ne_comm]
    simp [hset]
  by_cases hi : i.val = 0 <;> simp [hi, Nat.mul_comm] <;> exact hx

theorem rim_degree {r t : ℕ} (hr : 0 < r) (j : Fin t) (b : Fin 3) :
    (family r t).degree (.inr (j,b)) = 2 := by
  let z : Fin r := ⟨0,hr⟩
  have hz (v : Fin r) : v.val = 0 ↔ v = z := by simp [z, Fin.ext_iff]
  rw [degree_as_sum, Fintype.sum_sum_type]
  simp only [family, familyAdj]
  rw [Fintype.sum_prod_type]
  simp only [Fin.sum_univ_three]
  fin_cases b <;> simp [hz, (eq_comm (a := j)), Finset.sum_add_distrib]

theorem family_connected {r t : ℕ} (hr : 0 < r) : (family r t).Connected := by
  let z : Fin r := ⟨0, hr⟩
  apply (family r t).connected_iff_exists_forall_reachable.mpr
  refine ⟨Sum.inl z, ?_⟩
  rintro (i | ⟨j,b⟩)
  · by_cases h : z = i
    · subst i
      exact Reachable.refl _
    · exact (show (family r t).Adj (.inl z) (.inl i) from h).reachable
  · by_cases hb : b = 1
    · subst b
      have h₁ : (family r t).Adj (.inl z) (.inr (j,0)) := by simp [family, familyAdj, z]
      have h₂ : (family r t).Adj (.inr (j,0)) (.inr (j,1)) := by simp [family, familyAdj]
      exact h₁.reachable.trans h₂.reachable
    · exact (show (family r t).Adj (.inl z) (.inr (j,b)) from ⟨rfl, hb⟩).reachable

theorem clique_requires_colors (r t : ℕ) : r ≤ (family r t).chromaticNumber.toNat := by
  obtain ⟨c⟩ := colorable_chromaticNumber_of_fintype (family r t)
  have hinj := c.injective_comp_of_pairwise_adj
    (Sum.inl : Fin r → FamilyVertex r t) (fun _ _ hij => hij)
  simpa using Fintype.card_le_of_injective _ hinj

private theorem family_degree_sum {r t : ℕ} (hr : 0 < r) :
    ∑ v, (family r t).degree v = r * (r - 1) + 8 * t := by
  let z : Fin r := ⟨0,hr⟩
  have hz (i : Fin r) : i.val = 0 ↔ i = z := by simp [z, Fin.ext_iff]
  rw [Fintype.sum_sum_type, Fintype.sum_prod_type]
  simp only [clique_degree, rim_degree hr, hz, Finset.sum_add_distrib]
  simp
  omega

/-- Families with average degree exactly three and arbitrarily large chromatic number. -/
theorem unbounded_at_three (C : ℕ) :
    ∃ r t, IsEulerian (family r t) ∧ averageDegree (family r t) = 3 ∧
      C < (family r t).chromaticNumber.toNat := by
  let r := 2*C + 5
  let t := r * (2*C + 1)
  have hr : 0 < r := by dsimp [r]; omega
  refine ⟨r, t, ⟨family_connected hr, ?_⟩, ?_, ?_⟩
  · rintro (i | ⟨j, b⟩)
    · rw [clique_degree]
      by_cases hi : i.val = 0
      · simp [hi, r]
        exact ⟨C + 2 + t, by omega⟩
      · simp [hi, r]
        exact ⟨C + 2, by omega⟩
    · rw [rim_degree hr]
      decide
  · rw [averageDegree, family_degree_sum hr]
    simp only [Fintype.card_sum, Fintype.card_prod, Fintype.card_fin]
    have hden : (0 : ℚ) < (r + t * 3 : ℕ) := by positivity
    apply (div_eq_iff hden.ne').mpr
    have hsub : r - 1 = 2*C + 4 := by simp [r]
    rw [hsub]
    push_cast
    dsimp [r, t]
    push_cast
    ring
  · exact lt_of_lt_of_le (by dsimp [r]; omega) (clique_requires_colors r t)

end EulerianColor

#print axioms EulerianColor.unbounded_at_three
#print axioms EulerianColor.refute_0caab573
