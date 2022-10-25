# NAME

Finance::MIFIR::CONCAT - provides CONCAT code generation out of client data according to MIFIR rules

# SYNOPSIS

    use Finance::MIFIR::CONCAT qw/mifir_concat/;

    print mifir_concat({
        cc          => 'DE',
        date        => '1960-01-01',
        first_name  => 'Jack',
        last_name   => 'Daniels',
    });

# DESCRIPTION

## mifir\_concat

    Accepts hashref of person's data with keys: cc, date, first_name, last_name.

    Returns string representing CONCATed MIFIR ID.
