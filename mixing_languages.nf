#!/usr/bin/env nextflow

params.in = "Some text coming in"

process bashStuff {
    
    output:
    stdout result

    """
    printf '${params.in}'
    """
}

/*
process pythonStuff {

    output:
    stdout result

    """
    #!/usr/bin/env python3

    print(params.in)

    # print("hello world from Python! split: {}".format(in.split(" ")))
    """
}
*/

result.subscribe { println it }
