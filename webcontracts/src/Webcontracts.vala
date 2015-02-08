int main (string[] args) {
    stdout.printf( Build.to_string () ) ;

    if (args.length < 2) {
        stderr.printf ("You must provide two arguments: a contract name and a file path. \n   Example: %s flickr /my/path/to/image.png\n", Build.BINARY_NAME);
        return 1 ;
    }

     // FIXME non optimal. Ideally we'd only create UI if we're going to show
    //       UI, which is not the case for all contracts.
    Gtk.init (ref args);

    var contracts = Utils.get_contracts ();
    var name = args[1] ;
    var contract_arg = args[2] ;

    foreach (var contract in contracts) {
        if (contract.identifier == name) {
            contract.run (File.new_for_commandline_arg (contract_arg));
            return 0;
        }
    }

    // we didn't find a contract
    var list = "";
    foreach (var contract in contracts) {
        list += "\t" + contract.identifier + " (" + contract.full_name + ")\n";
    }

    stderr.printf ("No such service available.\n\nAvailable services:\n%s\n".printf (list));

    return 1;
}

