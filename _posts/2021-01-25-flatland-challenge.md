---
title: Tackling the Flatland challenge
tags: [Artificial Intelligence, Reinforcement Learning]
style: fill
color: dark
description: "An overview of my team's solutions and approaches to the 2020 NeurIPS Flatland challenge, by AIcrowd."
---

{% assign imgs="../assets/posts/flatland-challenge/" %}

![flatland-logo]({{imgs | append: "flatland-logo.svg"}})

### Introduction

The Flatland challenge is a competition organized by [AIcrowd](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/) and sponsored by SBB (Swiss Federal Railways), with the goal of fostering innovation in the train re-scheduling problem.

The scope of the challenge can be summarized as follows: given a set of trains positioned on a $H\times W$ grid, the task is to make each agent arrive at its assigned target, while also minimizing the cumulative traveling time.

As you may have noticed, I defined the problem a as re-scheduling one (with the _re_ prefix), because there is a very high chance that an _offline_ type of plan (meaning that one path for each agent is computed before they even enter the environment) may not work as expected. In particular, the Flatland environment introduces different types of complications:

- Trains can travel at different speeds, so that, for example, slower agents must learn to step back and stand still when faster ones decide to surpass them
- Trains can suffer from malfunctions, so that they would figure as out of order for a pre-determined number of steps, thus potentially blocking other agents from reaching their targets

Even though the complications listed above are not to be taken lightly, there's another intricacy which may not be evident at first: whenever two or more trains end up in the same straight rail, looking towards opposite directions, an unrecoverable situation might happen: the dreaded deacklock.

The worst thing about deadlocks is that, unlike malfunctions, once they happen there's no going back: at least two agents would be completely unable to reach their targets.

### Approaches

Our solutions mostly focus on implementing custom predictors and observators. Moreover, we tried to exploit both common models, like DQN, but also custom-made ones, like those based on GNNs. Let me explain better$\dots$

First of all, a predictor is a module which takes care of estimating where agents will be in the future, while an observator is another module which is tasked to encode the information of a state in a format which should be suitable for the component responsible for computing the best action that each agent should perform at any given time step.

Before explaining predictors and observators we have to take a step back: indeed, we decided to structure our approach from the ground up, starting from the environment itself. 

Inspired by the great work in [[1]](#1), we modeled the Flatland grid world as what we called a COJG (Cell Orientation Junction Graph): for each non-empty cell $(x, y)$ in the grid, at most $4$ nodes are allocated in the COJG graph, labeled as $(x, y, d)$ (where $(x, y)$ are spatial dimensions and $d\in \{N,E,S,W\} is the cardinal direction$). Node $(i, j, d_1)$ is then connected to node $(k, l, d_2)$ if and only if an agent is allowed to travel from cell $(i, j)$ to cell $(k, l)$, starting looking towards direction $d_1$ and ending oriented towards $d_2$. Finally, edges are merged together whenever they connect non-junction nodes (i.e. straight rails) and the new edge is assigned a weight proportional to the number of deleted edges.

![cojg]({{imgs | append: "cojg-env-32x16.png"}})

This new railway encoding allowed us to build more efficient and effective predictors and observators. In particular, we introduced a shortest/deviation path predictor, that estimates the position of an agent in future steps as follows: the agent either follows its shortest path or deviates from it. In this way, a prediction is composed by a shortest path with $s$ nodes and $m$ deviation paths (with $m \lt p$), again with the same number of nodes.

### Flows

### Conclusion


### References

- <a id="1">[1]</a>
  _Wälter Jonas (2020)_.\
  **Existing and novel Approaches to the Vehicle Rescheduling Problem (VRSP)**.\
  HSR Hochschule für Technik Rapperswil
