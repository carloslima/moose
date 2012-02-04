#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;
use Test::NoWarnings;
use Test::Memory::Cycle;
use Class::MOP;

subtest "No memory cycles in CMOP" => sub {
    memory_cycle_ok( Class::MOP::Class->create('DummyClass')->new_object,
        "Plain class is cycle-free" );
    memory_cycle_ok(
        Class::MOP::Class->create_anon_class->new_object,
        "Plain anonymous class is cycle-free"
    );
    memory_cycle_ok(
        Class::MOP::Class->create_anon_class->make_immutable->new_object,
        "Plain immutable anonymous class is cycle-free" );
};
