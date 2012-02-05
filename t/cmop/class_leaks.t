#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 3;
use Test::NoWarnings;
use Test::LeakTrace;
use Class::MOP;

subtest "Sanity check" => sub {
    leaks_cmp_ok {
        my $a = { a => 1 };
        my $b = { a => $a, b => 1 };
        $a->{b} = $a;
    }
    '=', 3, "Test::LeakTrace sanity check";

    no_leaks_ok {
        my $a = "Abc";
        my $b = { a => 5 };
    }
    "Test::LeakTrace sanity check";
};

subtest "No memory leaks in CMOP" => sub {
    no_leaks_ok {
        Class::MOP::Class->create('DummyClass')->new_object;
    }
    "Plain class is leak-free";

    no_leaks_ok {
        Class::MOP::Class->create('DummyClass2')->make_immutable->new_object;
    }
    "Plain immutable class is leak-free";

    no_leaks_ok {
        Class::MOP::Class->create_anon_class->new_object;
    }
    "Plain anonymous class is leak-free";

    no_leaks_ok {
        Class::MOP::Class->create_anon_class->make_immutable->new_object;
    }
    "Plain immutable anonymous class is leak-free";
};
