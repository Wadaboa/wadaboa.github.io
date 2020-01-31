---
title: Natural deduction in propositional logic
tags: [Logic, Propositional logic]
style: fill
color: primary
description: >-
	"A simple introduction to natural deduction in propositional logic, 
	which is a straightforward technique that allows us to derive conclusions from premises."
---

{% latex %}
\begin{eqnarray*}
(A\cup B)-(C-A) &=& (A\cup B) \cap (C-A)^c\\
&=& (A\cup B) \cap (C \cap A^c)^c \\
&=& (A\cup B) \cap (C^c \cup A) \\
&=& A \cup (B\cap C^c) \\
&=& A \cup (B-C)
\end{eqnarray*}
{% endlatex %}
