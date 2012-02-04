#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;
use Test::NoWarnings;
use Test::Memory::Cycle;
use Moose;

subtest "No memory cycles in Moose" => sub {
    do {

        package DummyRole;
        use Moose::Role;
        sub dummy { return "I'm a role" }
    };

    memory_cycle_ok( Moose::Meta::Class->create('DummyClass')->new_object,
        "Plain class is cycle-free" );
    memory_cycle_ok(
        Moose::Meta::Class->create( 'DummyClass2', roles => ['DummyRole'] )
          ->new_object,
        "Plain class with role is cycle-free"
    );

    memory_cycle_ok( Moose::Meta::Class->create_anon_class->new_object,
        "Plain anonymous class is cycle-free" );
    memory_cycle_ok(
        Moose::Meta::Class->create_anon_class->make_immutable->new_object,
        "Plain immutable anonymous class is cycle-free" );

    memory_cycle_ok( Moose::Meta::Role->initialize('DummyRole2'),
        'Plain role is cycle-free' );
    memory_cycle_ok(
        Moose::Meta::Role->create_anon_role,
        'Plain anonymous role is cycle-free'
    );
};
