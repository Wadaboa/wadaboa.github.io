---
title: Propositional logic
tags: [Logic]
style: fill
color: primary
description: "A broad introduction to propositional logic, the simplest possible form of reasoning."
---

{% include lib/mathjax.html %}

### Introduction

If you are not familiar with propositional logic, it is the simplest possible form of **reasoning**, which could be defined as:

<blockquote>
	<p>Reasoning is the action of thinking about something in a logical, sensible way</p>
</blockquote>

In propositional logic we can describe and manipulate some easy expressions in order to model a certain real-world scenario and to make **inferences**, i.e. _deductions_, in that specific model.
In **classical propositional logic** everything we can model are "imperative" sentences, like "3 is a prime number".
Usually, what we do is we assign a "name" to the sentences we are interested in and we try to derive some conclusions.

### Syntax & semantics

First of all, let's define what a proposition is, since it will be useful to understand the type of objects we are dealing with:

<blockquote>
	<p>A proposition is a statement or assertion that expresses a judgement or opinion.</p>
</blockquote>

In propositional logic, we can define an alphabet to work with, which is composed by:

- **Propositional symbols** $ A, B, C, ... $
- **Logical connectives** $ \lnot, \wedge, \vee and \to $
- **Logical constants** $ \bot $ (_verum_) and $ \top $ (_falsum_)

The propositional symbols are those "names" that we assign to interesting elementary sentences, which can be combined together using the logical connectives.

A **formula** (or well-formed formula) is a sequence of alphabet symbols generated with the following rules:

1. Every propositional symbol and logical constant is a formula (_atomic formula_)
2. Every sequence $ \lnot \phi $ is a formula
3. Every sequence $ \phi \square \psi $ is a formula, where $ \phi $ and $ \psi $ are formulas and $ \square \in {\wedge, \vee, \to} $

Everything we talked about so far is the **syntax** of a propositional logic language, while for the **semantics**, i.e. the _meaning_, we can use a valuation function which takes a formula and returns a boolean value, either 0 (false) or 1 (true). Let $ v $ be a **valuation function** such that:

- $ v(P) \in {0, 1} $, where $ P $ is a propositional symbol
- $ v(\top) = 1 $ and $ v(\bot) = 0 $
- $ v(\phi \wedge \psi) = min{v(\phi), v(\psi)} $
- $ v(\phi \vee \psi) = max{v(\phi), v(\psi)} $
- $ v(\phi \to \psi) = 0 if and only if v(\phi) = 1 and v(\psi) = 0 $, otherwise $ v(\phi \to \psi) = 1 $
- $ \lnot v(\phi) = 1 - v(\phi) $

So, by assigning a boolean value to every propositional symbol (this is called **interpretation**) we can obtain a valuation for an entire non-atomic formula.
Related to the interpretation of a formula, this could have one of the following instrinsic properties:

- A formula is **satisfiable** (**consistent**) iff there exists an interpretation in which the formula is true
- A formula is **valid** (**tautology**) iff it is true under every interpretation
- A formula is **unsatisfiable** (**inconsistent**) iff it is false under every interpretation

The problem of deciding whether a formula is satisfiable, valid or unsatisfiable is an important topic in logic overall. In propositional logic, this problem is _decidible_, i.e. there exists an effective procedure to determine if a formula is consistent or not, since there are only a finite number of different interpretations to try ($ 2^{N} $, where $ N $ is the number of propositional symbols in use).
Moreover, the mentioned problem (_SAT_ problem) is the first decision problem which was proved to belong to the complexity class of _NP-Complete_ problems, by Cook.

### Inference

If we have some logical statements that we know to be true (our _knowledge base_), sometimes we would like to see if we can derive some conlusions from this set of formuale. This process of logical deduction is also called **inference** and it could be described as a form of implication, named logical consequence.
We say that the formula $ \psi $ is a **logical consequence** of the formula $ \phi $, and we write it as $ \phi \vDash \psi $, whenever $ \psi $ is true under every interpretation in which $ \phi $ is true (when $ \phi $ is false $ \psi $ could be anything).
We also say that two formulas are logically equivalent if they are a logical consequence of each other ($ \phi \equiv \psi $ iff $ \phi \vDash \psi $ and $ \psi \vDash \phi $).
Now, we can define two of the most important theorems in this field, which are useful for practical inference-making procedures:

- **Deduction theorem**: $\phi \vDash \psi$ iff $\phi \to \psi$ is a valid formula
- **Proof by refutation**: $\phi \vDash \psi$ iff $\phi \wedge \lnot\psi$ is an inconsistent formula

The first result is mostly used in derivability schemes, like _natural deduction_ and _sequent calculus_, while the second one is generally used by mechanical theorem provers.
