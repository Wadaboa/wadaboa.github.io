---
title: Natural deduction in propositional logic
tags: [Logic, Propositional logic]
style: fill
color: primary
description: "A simple introduction to natural deduction in propositional logic, which is a straightforward technique that allows us to derive conclusions from premises."
---

{% include lib/mathjax.html %}

## A quick recap on propositional logic

If you are not familiar with propositional logic, it is the simplest possible form of logic, in which we can define and manipulate some easy expressions in order to model a certain real-world scenario and to make inferences, i.e. deductions, in that specific model.
In classical logic everything we can model are "imperative" sentences, like "3 is a prime number". In propositional logic, what we do is we assign a "name" to the sentences we are interested in and we try to derive some conclusions.
So, first of all, let's define what a proposition is:

<blockquote>
	<p>A proposition is a statement or assertion that expresses a judgement or opinion.</p>
</blockquote>

In propositional logic, we can define an alphabet to work with, which is composed by:

- Propositional symbols $$ A, B, C, ... $$
- Logical connectives $$ \lnot, \wedge, \vee and \to $$
- Logical constants $$ \bot $$ (_verum_) and $$ \top $$ (_falsum_)

The propositional symbols are those "names" that we assign to interesting sentences.

A **formula** (or well-formed formula) is a sequence of alphabet symbols generated with the following rules:

1. Every propositional symbol and logical constant is a formula (_atomic formula_)
2. Every sequence $$ \phi \square \psi $$ is a formula (_non-atomic formula_), where $$ \phi $$ and $$ \psi $$ are formulas and $$ \square \in {\lnot, \wedge, \vee, \to} $$
