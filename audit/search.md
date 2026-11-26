# 查重记录，2026-11-25

核查对象是 Ján Pastorek 公开候选 `0caab573`（rank 2062）的精确断言，即在至少两个顶点的欧拉图上以平均度的 $3/2$ 倍上界顶点色数。另行检索平均度恰为 3 的欧拉图族，以检查加强结论的已有来源。

## 原始档案与相邻问题

- 核对当日作者仓库远端 HEAD `4d1a8afc99447cacd2328cca20e47b6493e8dbc5`。原表该条状态为 `proposed`，`known_as`、`lean_statement` 与 `lean_proof` 为空。排名表将它归为 `promising:class`。在三份作者反例列表（1,413、150、0 条）以及 58 条金标准记录里，以 ID 和精确不等式搜索均无匹配。主反例文件中同时提到色数和平均度的三个条目涉及不同系数或逻辑方向。[作者原始记录](source.json) · [候选排名](https://github.com/JanPastorek/AutoGraphForge/blob/4d1a8afc99447cacd2328cca20e47b6493e8dbc5/results/audit_top_normalised.json) · [主反例表](https://github.com/JanPastorek/AutoGraphForge/blob/4d1a8afc99447cacd2328cca20e47b6493e8dbc5/results/cegis_refuted.json)
- 查看该仓库所有状态的公开议题，只有 #1。其候选 ID 为 `f0a6258d`，公式是 $\chi\le(6/7)\bar d+24/7$，证据为 $K_{19}$。该图的色数为 19、平均度为 18，满足本题的 $19\le27$。因此 #1 提供了需要区分的已解决猜想。[作者议题 #1](https://github.com/JanPastorek/AutoGraphForge/issues/1)
- 以 `Eulerian graph average degree arbitrarily large chromatic number` 和 `average degree exactly 3 chromatic number Eulerian` 检索。一个接近的既有构造是 Mark Muldoon 讲义中习题 9(b) 的 $K_4$ 加一条长尾，它用度为 1 的顶点并降低平均度，说明一般图的色数不能受该类平均度界控制。它给出了本项目所用思路的背景。本项目用环保持连通和全偶度，并处理指定的 $3/2$ 不等式与平均度精确等于 3 的情况。[原讲义，习题 9(b)](https://personalpages.manchester.ac.uk/staff/mark.muldoon/Teaching/DiscreteMaths/Solutions/Solutions2.pdf#page=7)

## 逐平台检索

| 平台 | 查询和结果 |
|---|---|
| arXiv | `all:"0caab573"` 与 `all:"Eulerian" AND all:"chromatic number" AND all:"average degree"` 在 Atom 接口均无条目。`all:"AutoGraphForge"` 找到原论文。[精确 ID 查询](https://export.arxiv.org/api/query?search_query=all%3A%220caab573%22) · [Pastorek 原文](https://arxiv.org/abs/2609.03478v1) |
| Google Scholar | 桌面浏览器查询 `"0caab573" graph` 显示无匹配。检索 `"Eulerian" "chromatic number" "average degree"` 约 281 项；核查了首屏十项，涉及 Klein 瓶三角剖分、伪色数、Alon–Tarsi 等问题，未见本题解答。余下结果未逐项阅读。直接 HTTP 检索 `"0caab573" "chromatic"`、`"Eulerian" "chromatic number" "average degree"` 与 `"AutoGraphForge"` 均得到 JavaScript 验证响应。直接客户端没有可读取的结果列表。[按 ID 查询](https://scholar.google.com/scholar?q=%220caab573%22+chromatic) · [按题意查询](https://scholar.google.com/scholar?q=%22Eulerian%22+%22chromatic+number%22+%22average+degree%22) |
| OpenAlex、DataCite、Figshare | 三站分别以 `0caab573` 查询均为零。宽泛短语 `Eulerian chromatic average degree` 在 OpenAlex 命中数百条，所阅主要相关记录讨论欧拉单位球、一般染色或极值图论；其余两站用同样短语无结果。OpenAlex 的 `AutoGraphForge` 命中 5 条，含原论文及四项关于其他候选的记录（燃烧与 Slater 数、罗马支配与电力支配、罗马与双罗马支配、燃烧与电力支配）。DataCite 的 5 条包括 DOI 版本变体；Figshare 的项目名查询返回一条罗马支配研究。Zenodo 直接搜索端点返回 HTTP 403，补查了载入上述索引的 Zenodo 记录。[OpenAlex](https://api.openalex.org/works?search=AutoGraphForge) · [DataCite](https://api.datacite.org/dois?query=AutoGraphForge) · [Figshare](https://figshare.com/search?q=AutoGraphForge) |
| 引证链 | OpenAlex 原论文对象 `W7208712928` 的被引计数和按引用者筛出的条目均为 0；Semantic Scholar 的前向引证列表为空。以原项目名称检索仍找到直接提及它的后续材料，例如处理燃烧数与电力支配的 Zenodo 报告。[OpenAlex 前向引用](https://api.openalex.org/works?filter=cites:W7208712928) · [Semantic Scholar](https://api.semanticscholar.org/graph/v1/paper/arXiv:2609.03478/citations?fields=title%2Cyear) · [其他候选的后续报告](https://doi.org/10.5281/zenodo.24383172) |
| MathOverflow | Stack Exchange 的 `site=mathoverflow` 高级查询分别组合 ID 与 `chromatic`、欧拉图与色数和平均度，以及 `AutoGraphForge`，均无命中。[MathOverflow 查询](https://api.stackexchange.com/2.3/search/advanced?site=mathoverflow&q=0caab573) |
| GitHub 代码 | 已授权的全站默认分支代码搜索 `"0caab573" "chromatic_number"`、`"0caab573" "Pastorek"` 以及 `"chromatic_number ≤ ((3/2) · average_degree)"` 均返回零条。宽词 `"Eulerian" "chromaticNumber" "averageDegree"` 的 16 项包括图 API、基准描述及 Lean-HoG 的查询语言。该 Lean 文件为图不变量的检索接口。[按 ID 检索](https://github.com/search?q=%220caab573%22+%22chromatic_number%22&type=code) · [Lean-HoG 文件](https://github.com/katjabercic/Lean-HoG/blob/5570915ea176254abbc7f9bd4da0569ab6775372/LeanHoG/Tactic/SearchDSL.lean) |
| GitHub 议题与拉取请求 | `"0caab573" "chromatic"` 命中一条 IPFS 项目的哈希碰撞。含三个数学词的短语组合命中 5 项，逐项阅读后未见本题公式。Graph-Theory-LLM-Proofs 的 PR #3 中 `Eulerian` 属于有向四环问题，`3/2` 出现在另一项渐近估计中。另读作者唯一的已知相关议题，见上。[议题搜索](https://api.github.com/search/issues?q=%220caab573%22+%22chromatic%22) · [PR #3](https://github.com/graph-theory-AI/Graph-Theory-LLM-Proofs/pull/3) |
| Lean Zulip 与 Mathlib | 所有 web-public 频道分别查询 `0caab573`、`Eulerian chromatic average degree` 和 `AutoGraphForge`，返回 0 项，三个响应均为 `found_oldest=true` 与 `history_limited=false`。在固定 Mathlib 源树查编号与 Eulerian、averageDegree、chromaticNumber 的组合，未见此题的定理；着色和连通性使用项目中引用的标准定义。[Lean Zulip](https://leanprover.zulipchat.com/#narrow/channels/web-public/search/0caab573) · [Mathlib 版本](https://github.com/leanprover-community/mathlib4/tree/fc4f59e577feb1a4956671bc04ac18aaaf8cd842) |

这些查询支持“作者记录为提出，已核对的公开来源未见本条的既有解答”。不同语言、不同公式表述、未索引资料与引证滞后，都可能影响检索的完整性。精确构造和内核核证提供数学证据；全球优先权另需人工文献判断。

## 发布后独立复核

2026 年 11 月 25 日（洛杉矶）从已发布提交 `05284fc03735b7589a2a79336ee63a621e6ab8ea` 开始复核。本仓保存的候选记录与上游 JSON 逐字段相同；规范化表按公式给出 `rank_all=2062`、`rank_novel=1917`，分类为 `promising:class`。上游当天主分支仍指向同一固定提交，主反例表的 1,413 行均没有本题 ID，上游唯一的公开议题 #1 对应另一个线性不等式。[固定原始表](https://github.com/JanPastorek/AutoGraphForge/blob/4d1a8afc99447cacd2328cca20e47b6493e8dbc5/results/cegis_results.json) · [排名表](https://github.com/JanPastorek/AutoGraphForge/blob/4d1a8afc99447cacd2328cca20e47b6493e8dbc5/results/audit_top_normalised.json) · [上游议题](https://github.com/JanPastorek/AutoGraphForge/issues/1)

**已有数学背景。** Muldoon 讲义的习题 9(b)、图 2 用四点团接长尾来降低全图的平均度。沿单个公共顶点拼接两个图时，所得图的色数等于两者色数的较大值。这也是单顶点粘合的色多项式公式的直接推论，两边可通过置换颜色使公共顶点同色。本项目把奇数阶团与环沿顶点拼接，借环保持全部顶点度为偶数，再利用每个新增四边形贡献 3 个顶点及 8 个度数单位，把全图平均度精确调到 3。该固定值只针对整个图；团子图的平均度仍可随阶数增长。[Muldoon 习题 9(b)，第 7 页](https://personalpages.manchester.ac.uk/staff/mark.muldoon/Teaching/DiscreteMaths/Solutions/Solutions2.pdf#page=7) · [单顶点粘合的色多项式公式](https://ptwiddle.github.io/Graph-Theory-Note-Request/Colouring/)

补查使用 `"0caab573" "Eulerian" chromatic number counterexample`、`"AutoGraphForge" "Eulerian" chromatic number average degree counterexample 3/2`、`connected Eulerian graphs "average degree" "chromatic number" arbitrarily large` 等。按 ID 查 OpenAlex、DataCite 与 MathOverflow 均为零；GitHub 议题查询 `"0caab573" "chromatic"` 返回一个不相关的 IPFS 项目。本轮按 ID 请求 arXiv Atom 接口超时。已发布的本仓库可直接访问，说明按编号查询也可能漏项。在本轮读取的文献中未发现另一份明确处理此候选或给出相同固定均度欧拉图结论的工作。索引对教材例题、不含编号的等价构造及新发仓库的覆盖有限。[OpenAlex](https://api.openalex.org/works?search=0caab573) · [DataCite](https://api.datacite.org/dois?query=0caab573) · [MathOverflow 查询](https://api.stackexchange.com/2.3/search/advanced?site=mathoverflow&q=0caab573) · [GitHub 议题查询](https://api.github.com/search/issues?q=%220caab573%22+%22chromatic%22)
