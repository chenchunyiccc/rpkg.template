#set text(font: "Noto Sans SC")

= 分段回归与季节分解函数

本文档说明 `Component.R` 中的四个函数。

== RemoveSeasonal

计算季节均值与去季节序列（距平）。

- `y`：观测值向量
- `t_mmdd`：与 `y` 对应的月日编码，如 `101` 表示 1 月 1 日

返回 `mu`（按月日升序排列的季节均值）与 `anomaly`（去季节序列）。

设升序去重后的月日为 $s_1, s_2, ..., s_m$，$k(i)$ 为 $t_i$ 对应的序号，$mu_k$ 为满足 $t_i = s_k$ 的观测值均值，则距平为

$ "anomaly"_i = y_i - mu_(k(i)) $

== LS_MultiBreaks

多断点分段回归（同斜率、不同截距）。

- `Y`：响应向量
- `X`：自变量（通常为时间）
- `Ips`：各段末尾位置，末位为序列长度

设计矩阵为

$ bold(X)_d = mat(bold(1), x - overline(x), I_2, ..., I_m) $

其中 $I_j$ 为第 $j$ 段的指示向量（从第 2 段开始）。系数通过最小二乘求解。

== LS_OneBreak

单断点分段回归（同斜率、不同截距）。断点 $I_c$ 将序列分为
$[1, I_c]$ 与 $[I_c + 1, n]$ 两段；当 $I_c$ 为 `NA` 时退化为普通线性回归。

设计矩阵为

$ bold(X)_d = mat(bold(1), x, bold(1)_("step")) $

其中 $bold(1)_("step") = (0, ..., 0, 1, ..., 1)^T$，前 $I_c$ 个分量为 0。

== lm_solve

最小二乘求解核心，调用 `.lm.fit`。

- `design`：设计矩阵
- `response`：响应向量
- `only.SSE`：为 `TRUE` 时仅返回残差平方和

返回 `coef`（系数）、`fitted`（拟合值）、`resi`（残差）与 `SSE`（残差平方和），

$ "SSE" = sum_i r_i^2 $
