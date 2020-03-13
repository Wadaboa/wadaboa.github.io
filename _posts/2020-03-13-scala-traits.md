---
title: Java interfaces vs. Scala traits
tags: [Scala]
style: fill
color: info
description: "The highlighting of some key differences between Java interfaces and the fancy Scala traits."
---

### Introduction

One key idea in **OOP (Object-Oriented Programming)** is the so-called **information hiding**, which is a form of abstraction whereby the public interface of an object gets _decoupled_ from its internal workings. This concept of separation is usually the core idea of _abstract classes_ and _interfaces_, in which a set of customers (a _concrete class_) would like that each customer (an _instance_ of the concrete class) could use the service (an _interface's function_) provided by a specific supplier (the _interface_). In this blog post we are going to develop a deeper understanding of what interfaces are, in general, and how they differ from a programming language to another.  

### Java interfaces

In **Java**, an **interface** is very similar to an abstract class, with the following main differences:
* Interfaces are declared using the `interface` keyword, rather than the `class` keyword
* A class can implement an interface using the `implements` keyword, rather than the `extends` keyword 
* Functions are declared as abstract methods, i.e. they don't provide an implementation
* Functions are automatically declared with the `public` visibility 
* Variables are automatically declared as `public`, `static` and `final`, since an interface cannot be directly instantiated

The cool thing about interfaces is that they provide a way to perform a sort of _multiple inheritance_, since a class can implement more than one interface, while also eventually extending a single class. For example:
```java
public interface A {
    public void foo();
}

public interface B {
    public void bar();
}

public class C implements A, B {
    public void baz();
}
```
An interface can also extend another interface, by means of the same **inheritance** rules applied to standard Java classes. For example:
```java
public interface A {
    public void foo();
}

public interface B extends A {
    public void bar();
}
```

Since **Java 8**, interfaces got richer, with additional important features which brings them closer to other implementations of the same concepts in other languages, like Scala. These useful new features free the programmer from the constraints imposed by having to stick with just abstract methods in interfaces. For example, with Java 8 you can implement a **static function** directly in the interface, leading to very useful applications like standard _factory methods_:
```java
public interface A() {
    public static A factory() {
        return new B();
    }
}

public class B implements A() { ... }
```

Another useful addition is in the so called `default` methods, which are a good way to provide default implementations of some interface functions. In this way, classes that implement that specific interface are not obliged to provide the actual code to perform that operation, to be declared as concrete classes. Obviously, this feature is mostly related to the scalability of an interface, rather than to its core operations, since the best practice for a class implementing that interface will always be to provide its specific implementation of the default method. 
```java
public interface A {
    default boolean foo() {
        return true;
    }
}
```

### Scala traits

**Scala** traits are very similar to Java interfaces, since they provide a way to inject specific behaviors into a class, using a set of methods defined in the implemented trait. These behaviors should then be parametrized, according to the actual mission of the class.
```scala
trait A {
    def foo()
}
```

Scala traits could be seen as rich interfaces, since they provide a way to implement both abstract and **non-abstract** function definitions, out of the box. For example, we could have the following definition, without the need of using the `default` keyword, as in Java 8:
```scala
trait A {
    def foo() = println("foo")
}
```

A Scala _class/object_ can inherit from multiple traits at the same time. For the _single inheritance problem_, we could have:
```scala
trait A {
    def foo() = println("foo")
}

class B() extends A {
    def bar() = println("bar")
}
```

For the _multiple inheritance problem_, we could instead have:
```scala
trait A {
    override def foo() = println("foo")
}

trait B {
    override def foo() = println("bar")
}

class C() extends A with B {
    def bar() = println("bar")
}
```

Alternatively to `class C() extends A with B`, we could have also written `class C() with A with B`.\
Beware that the **order** in which traits are listed actually matters, since the last trait will be considered first in case of traits that override methods (in our example, calling `foo()` on an instance of type `C` will print out "_bar_" instead of "_foo_").

A very useful thing which distinguishes Java 8 interfaces with default methods w.r.t. Scala traits is that the latter provide the so called **dynamic binding** of `super`: the `super` keyword can be used inside a trait to refer to the superclass of the class implementing the trait. Obviously, the `super` keyword cannot be _statically interpreted_ because the trait can be mixed-in different classes, with different superclasses; so, it has to be _dinamically bound_ to the superclass of the mixed-in class. For example:
```scala
trait A {
    def foo() = println(super.toString)
}

class B() {
    override def toString = "Superclass"
}

class C() extends B with A {
    override def toString = "Derived class"
}
```
In this example, calling `foo()` on an instance of `class C` will actually print out "_Superclass_".

These tools give the programmer an easy way to **extend** the language with new primitives and mechanisms that resemble **native**, in order to "_scale_" the software to suit its needs.
