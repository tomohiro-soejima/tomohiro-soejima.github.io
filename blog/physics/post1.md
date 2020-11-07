@def title = "Where do quantum spin chains come from?"
@def hascode = true
@def published = Date(2020, 11, 5)
@def rss = "This post explains what quantum spin chain is, its mathematical properties and more"
@def author="Tomohiro Soejima"

@def tags = ["syntax", "code"]

For undergraduate students interested in theoretical physics research, one of the largest initial hurdles is the apparent difference between what you learn in classes and what you are supposed to study in a theory project.

In the case of theoretical condensed matter physics, the concept of **quantum spin chain** is often the first object you need to learn. As I have mentored multiple undergraduate students, I've often found myself explaining this over and over again. This post is an attempt to explain spin chains in as self-contained a manner as possible. 

I assume familiarity with undergraduate quantum mechanics (think Griffiths). Some familiarity with statistical mechanics might be helpful, but should not be necessary.

@def maxtoclevel=3
\toc

## Classical spin chains

Before we delve into quantum spin chains, let me first explain what a classical spin chain is.

Consider a piece of permanent magnet. Its magnetization comes from constituent electrons that carry spin-$1/2$. When the microscopic spins are aligned with each other, the system is a magnet, whereas the system is not a magnet if the spins are pointing in random directions. Just like liquid water and ice are distinc phases of matter, magnet and non-magnet belong to different phases of matter. We call the magnetic phase an **ordered** phase, and the nonmagnetic phase a **disordered** phase.

Magnets in real like comes in various forms and shapes, but physicists like to extract the essential elemenets of any phenomenon. We strive for a description of the system in terms of the smallest number of ingredients. Such a description is called a **model**. In the case of magnet, let's try making the following simplification.

1. Electrons are frozen in some regular lattice. Therefore, the directions of the electron spins are the only degrees of freedom.
1. Further, we assume the spin can only point in one of two directions: up and down.

 

## Summary and further readings

The title of this post is inspired by an awesome set of lecture notes by ???? ([where do quantum field theories come from]()). 
