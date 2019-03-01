#include "inc/stdafx.hpp"
#include "inc/data.hpp"
#include "inc/main.extend.hpp"
#include "inc/preprocess_data.hpp"

/**
 * @brief main The main entry of program
 * @return The exit flag
 */
int main(int argc, char** argv) {
    // exiting flag
    bool exiting = false;
    vector<future<void>> thread_pool;
    // random seed updator
    thread_pool.push_back(std::async(std::launch::async, [&exiting]() { while(!exiting) { updateseed(); std::this_thread::sleep_for(std::chrono::milliseconds(100));}} ));

    // obtain the args
    auto opt = process_args(argc, argv);

    unused auto [data, title] = Data::CSV::load(opt["data"].as<string>());

    Data::prepare_data<double, 3, 1>(data, 1);
    Data::prepare_data<double, 7, 1>(data, 1);
    Data::prepare_data<double, 14, 1>(data, 1);
    Data::prepare_data<double, 28, 1>(data, 1);
    Data::prepare_data<double, 56, 1>(data, 1);

    // exit the program
    exiting = true;
    while(!thread_pool.empty()) { thread_pool.back().get(); thread_pool.pop_back(); }
    exit(EXIT_SUCCESS);
}
