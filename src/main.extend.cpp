#include "inc/main.extend.hpp"
#include <unordered_map>
#include <boost/algorithm/string.hpp>

po::variables_map process_args(int argc, char** argv) {
    po::options_description desc("Allowed options");
    unused auto prob_checker = [](char const * const opt_name) {
        return [opt_name](const scalar& v) {
            if(v < 0 || v > 1)
                throw po::validation_error(po::validation_error::invalid_option_value, opt_name, std::to_string(v));
        };
    };
    auto avail_options = [](const string& opt_name, const initializer_list<string>& lists) {
        unordered_map<string, void*> mp;
        for(auto l : lists) mp.insert({boost::to_lower_copy(l), nullptr});
        return [opt_name, mp](const string& v) {
            if(!mp.count(boost::to_lower_copy(v)))
                throw po::validation_error(po::validation_error::invalid_option_value, opt_name, v);
        };
    };
    desc.add_options()
            ("help", "Produces this help message.")

//            ("agents",
//                po::value<size_t>()
//                    ->default_value(1),
//             "The number of agents to run.")

//            ("iters",
//                po::value<size_t>()
//                    ->default_value(20),
//            "The iterations that the program should run itself.")

//            ("trials",
//                po::value<size_t>()
//                    ->default_value(200),
//             "The agents' trials at each program iteration.")

//            ("cycles",
//                po::value<size_t>()
//                    ->default_value(5),
//             "The number of agents learning cycle.")

//            ("refmat-grind",
//                po::value<size_t>()
//                    ->default_value(3),
//             "The grind value of fci method.")

//            ("beta",
//                po::value<scalar>()
//                    ->default_value(.01, ".01")
//                    ->notifier(prob_checker("beta")),
//             "The learning rate(beta) rate, should be in range of [0,1].")

//            ("network",
//                po::value<scalar>()
//                    ->default_value(.9, ".90")
//                    ->notifier(prob_checker("gamma")),
//             "The discount rate(gamma) rate, should be in range of [0,1].")

            ("future",
                po::value<size_t>()
                    ->default_value(1),
            "For how long of the future should the program predict? (e.g. `--future 1` mean predict one ahead)")

            ("window",
                po::value<size_t>(),
             "The window's size for training/predicting the values")

            ("stage",
                po::value<string>()
                    ->default_value("train")
                    ->notifier(avail_options("stage", {"train", "pred"})),
             "The stage of the program to be executed, can be [train, pred].")

            ("method",
                po::value<string>()
                    ->default_value("days")
                    ->notifier(avail_options("method", {"days"})),
             "The training/prediction method, can be [days].")

            ("data",
                po::value<string>(),
             "The data file to train/predict.")

            ("model",
                po::value<string>(),
             "The file containing the previous generated model for training/predicting purposes.")

            ("save-model",
             "Save the trained model into the `--model` file.")
        ;
    po::variables_map vm;
    try {
        po::store(po::parse_command_line(argc, argv, desc), vm);
        po::notify(vm);
    } catch(po::error& e) {
        std::cerr << "ERROR: " << e.what() << std::endl << std::endl;
        std::cerr << desc << std::endl;
        exit(EXIT_FAILURE);
    }
    // if help required; print the help and exit.
    if (vm.count("help")) { cout << desc << endl; exit(EXIT_SUCCESS); }
    // return the fetched variable map
    return vm;
}
