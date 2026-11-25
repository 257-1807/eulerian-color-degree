# 欧拉图的平均度不能控制色数

AutoGraphForge 候选 `0caab573` 断言，每张至少有两个顶点的欧拉图都满足 $\chi(G)\le\tfrac32\bar d(G)$。将 $K_5$ 和六边形 $C_6$ 各取一个顶点并合为同一个顶点，便得到一张 10 顶点的反例。其色数为 5，平均度为 $16/5$，所以候选要求 $5\le24/5$。

更强地说，**即使平均度恰好等于 3，有限连通欧拉图的色数仍然无界**。10 顶点见证在上一轮仅作本地备用候选，本轮首次将其整理为公开项目，并加入固定平均度图族的全参数证明。两个结论都已经在 Lean 4 中编译并通过内核重放。[完整证明](EulerianColor.lean) · [公理审计](audit/axioms.log)

## 来源与原文

Ján Pastorek 在 *AutoGraphForge: Towards Automated Graph Theory Discovery*（2026，arXiv:2609.03478v1）§4.2 报告了生成和筛选所得的猜想。本文处理的是配套公开仓库中的一条记录。其 ID 为 `0caab573`，规范化审计表总排名为 2062。在提交 `4d1a8afc99447cacd2328cca20e47b6493e8dbc5` 中，作者把它标为 `proposed`；`lean_statement` 和 `lean_proof` 均为空。[原论文](https://arxiv.org/abs/2609.03478v1) · [候选总表](https://github.com/JanPastorek/AutoGraphForge/blob/4d1a8afc99447cacd2328cca20e47b6493e8dbc5/results/cegis_results.json) · [排名表](https://github.com/JanPastorek/AutoGraphForge/blob/4d1a8afc99447cacd2328cca20e47b6493e8dbc5/results/audit_top_normalised.json)

原作者 `statement` 字段的逐字引文如下。

> ((nontrivial) ∧ (eulerian)) ⇒ chromatic_number ≤ ((3/2) · average_degree)

此处的图是有限无向简单图。作者将“非平凡”定义为顶点数至少为 2，将“欧拉”定义为连通且所有顶点的度都是偶数。色数是将相邻顶点涂成不同颜色所需的最少颜色数；平均度是度数总和除以顶点数。[作者图类定义](https://github.com/JanPastorek/AutoGraphForge/blob/4d1a8afc99447cacd2328cca20e47b6493e8dbc5/lean_project/LeanProject/GraphInvariantsComputable.lean#L271-L301) · [原记录摘录](audit/source.json)

## 10 个顶点如何推翻全称命题

取顶点 $0,1,2,3,4$，加入这五点之间的全部十条边，再加入环 $0,5,6,7,8,9,0$ 的六条边。两部分共用顶点 0，整张图连通。顶点 0 的度为 6，顶点 1 到 4 的度都是 4，顶点 5 到 9 的度都是 2，故整图欧拉。平均度为

$$\bar d(G)=\frac{6+4\cdot4+5\cdot2}{10}=\frac{16}{5}.$$

五点团需要五种颜色。给顶点 0 至 4 分别赋色 0 至 4，再给顶点 5 至 9 依次赋色 $1,2,1,2,1$，所得染色合法，恰用五色。于是 $\chi(G)=5>\tfrac32(16/5)=24/5$。

## 平均度固定为 3 时色数仍然无界

给定任何自然数 $C$，令 $r=2C+5$，从 $K_r$ 中选一个顶点 $z$。添上 $t=r(r-4)$ 个四边形，每个四边形都经过 $z$，其余三个顶点全是新顶点，而且分别属于自己的四边形。

每个普通团顶点的度为 $r-1$，顶点 $z$ 的度为 $r-1+2t$，四边形上的新点度为 2。因为 $r$ 是奇数，这些度都是偶数。各四边形与团均包含 $z$，图连通。

顶点数为 $r+3t$，度数总和为 $r(r-1)+8t$。两者满足

$$r(r-1)+8t-3(r+3t)=r(r-4)-t=0.$$

所以平均度严格等于 3。图中仍含 $K_r$，必须使用至少 $r>C$ 种颜色。这个构造对 $C=0$ 也成立，全部参数给出非空有限图。它还排除了任何仅依赖平均度、对所有连通欧拉图都有效的有限色数上界。

## 数学陈述与 Lean 定义的对照

| 概念 | Lean 对应 | 核对内容 |
|---|---|---|
| 有限非平凡无向简单图 | `SimpleGraph V`、`[Fintype V]`、`2 ≤ Fintype.card V` | 对任意有限顶点类型量化；邻接可判定用于计算度数，有限图可在经典逻辑中选取该实例。 |
| 欧拉性 | `IsEulerian G` | 同时要求 `G.Connected` 与每个顶点度为偶数。 |
| 顶点色数 | `G.chromaticNumber.toNat` | Mathlib 色数取值于带无穷的自然数。每个有限图都有逐顶点着色，故转换到自然数保留色数。 |
| 平均度和系数 | `averageDegree G`、`(3 / 2 : ℚ)` | 先计算所有顶点的度之和，再于有理数中除以顶点数。保留精确分数。 |
| 10 点反例 | `witness`、`witness_eulerian`、`witness_average`、`witness_chromatic` | 图的顶点是 `Fin 10`，代码直接指定邻接并核证欧拉性、平均度和色数。 |
| 原猜想的否定 | `refute_0caab573` | 对原全称命题取否定；代入见证时保留原题每一个前提。 |
| 四边形族及加强结论 | `family r t`、`unbounded_at_three` | 对任意 $C$ 产生一张平均度为 3 且色数严格大于 $C$ 的有限欧拉图。 |

## 查重及复现

2026-11-25 核查作者的状态表、反例和全部公开议题，并按编号、系数及自然语言关键词查询 arXiv、引用数据库、MathOverflow、GitHub、Google Scholar、Lean Zulip 与 Mathlib。作者议题 #1 给出的 $K_{19}$ 反驳另一条色数不等式；它在本题中满足 $19\le27$。用稀疏部分降低高色数核心的平均度是已有的教科书技巧。已核查范围内未发现针对本题的完整先行解答，也未找到给出相同定平均度欧拉图结论的条目；无法据此确定全球发表优先权。[检索记录和可访问性](audit/search.md)

项目固定 Lean 4.36.0 和 Mathlib 的 Git 提交 `fc4f59e577feb1a4956671bc04ac18aaaf8cd842`。安装 Elan 后，在项目根目录运行以下命令。

```sh
lake exe cache get Mathlib.Combinatorics.SimpleGraph.Coloring.Vertex Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected Mathlib.Combinatorics.SimpleGraph.Finite Mathlib.Tactic
lake --wfail build
lake build
lake env lean -DwarningAsError=true EulerianColor.lean
lake env leanchecker --verbose EulerianColor
python3 scripts/check.py
```

实际公理输出如下。[严格构建](audit/build.log) · [公理日志](audit/axioms.log) · [内核重放](audit/kernel-replay.log)

```text
'EulerianColor.unbounded_at_three' depends on axioms: [propext, Classical.choice, Quot.sound]
'EulerianColor.refute_0caab573' depends on axioms: [propext, Classical.choice, Quot.sound]
```

Python 脚本用整数和有理数检查 $K_5$ 与长度为 3 至 12 的环的并点图，检验连通性、度数、五点团下界和实际五色染色；环长为 5 时恰取等，环长为 6 时首次违反该族中的上界。脚本还对 $C=0,\ldots,8$ 直接构图并核对四边形族的度数与团大小。无限范围由上述 Lean 定理覆盖。[实验程序](scripts/check.py) · [实际输出](audit/examples.log)
