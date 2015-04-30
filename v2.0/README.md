Crystal Cube v 2.0
==================
Authors: Eric Heep & Danny Clarke
Chuck and Arduino code for the generation of a Tenney Crystal and the propagation of the crystal's pitches through an array of Piezo speakers

Some By-the-Book Planning
=========================
Problem Description:
--------------------
* 1. Need to generate a pitch lattice using James Tenney's formula for crystal-growth based harmonic space
* 2. Need to propogate those pitches through an array of arduino-controlled piezos

Problem Components:
-------------------
* 1. lattice generation
* 2. assignment of pitches to speakers
* 3. triggering of speakers in speaker arrays 
** 3a. determine patterns for propogation
** 3b. determine connected components for speakers
* 4. Regeneration/updating of lattice and reassignment of pitches to speakers

Would-be-nice:
--------------
* 1. multiple propogation patterns occuring at the same time and overlapping

Design:
-------
* Classes:
** Lattice - pitch lattice that generates pitches according to James Tenney Harmonic space formula
** PiezoArray - array of piezo speakers, onto which the lattice's pitches are mapped
** Patterns - collection of propagation patterns and rules for connectivity
** Session - manager class that facilitates communication amongst these objects

