# kube-better-node

This small program doest the only thing [kubernetes-sigs/descheduler](https://github.com/kubernetes-sigs/descheduler) can't do. It will evict Pods to better nodes, based on `preferredDuringSchedulingIgnoredDuringExecution` `nodeAffinity` terms.

## Why?


There're at least two rotten unmerged PRs in descheduler repository:

* [#130](https://github.com/kubernetes-sigs/descheduler/pull/130) (`FindBetterPreferredNode` and `CalcPodPriorityScore` are inspired by it. Thanks [@tsu1980](https://github.com/tsu1980))
* [#129](https://github.com/kubernetes-sigs/descheduler/pull/129)

In fact, this functionallity will be never implemented in Descheduler. 

As [@asnkh](https://github.com/asnkh) said in [#211](https://github.com/kubernetes-sigs/descheduler/issues/211#issuecomment-602026583):

> ...unless descheduler can make the same decision as kube-scheduler, it can cause this kind of ineffective pod evictions. I have no good idea to overcome this difficulty. Copying all scheduling policies in kube-scheduler to descheduler is not realistic.

## Use case

However, there're real world use-cases, where such dumb eviction can be usefull. 

For exmaple, when a project is small and there's a need to use some special Spot instance node type (such as Tesla `p2.xlarge`).
When this instance is taken back from you by AWS, but your project can afford some performance degradation for a short period of time (untill there's a new node of `p2.xlarge` given), `kube-scheduler` will place it on some other node available at the moment.
But when finally new Tesla node will join the cluster, there's nothing to schedule your project's Pod back to it. 

Here **kube-better-node** can be usefull. 

## Installation

```
helm repo add decayofmind https://decayofmind.github.io/charts/
helm install kube-better-node decayofmind/kube-better-node
```