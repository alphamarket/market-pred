#ifndef PREPROCESS_DATA_HPP
#define PREPROCESS_DATA_HPP

#include "data.hpp"

namespace Data {
  // `IN` days before
  template<class T, size_t IN, size_t OUT = 1>
  Database<T, IN, OUT>* const prepare_data(const Vector2D<T>& data, const size_t index) {
    // create the database instance
    Database<T, IN, OUT>* const database = new Database<T, IN, OUT>();
    // iterate for each rows of data
    for(size_t row = 0; row < data.size() - OUT - IN; row++) {
      // init inputs
      T in[IN];
      // init outputs
      T out[OUT];
      // read `IN` days ahead as inputs
      for(size_t i = 0; i < IN; i++)
        in[i] = (data[row + i + 1][index] / data[row + i][index]) - 1;
      // read `OUT` days after `IN` days as outputs!
      for(size_t i = 0, j = IN; j < IN + OUT; i++, j++)
        out[i] = (data[row + j + 1][index] / data[row + j][index]) - 1;
      // append to database
      database->push_back(new Dataset<T, IN, OUT>(in, out));
    }
    // the last item of database's target should be the last item of data at the given index
    assert(database->back()->targets[OUT - 1] == data.back()[index] / data.at(data.size()-2)[index] - 1);
    // return the database
    return database;
  }
}

#endif // PREPROCESS_DATA_HPP
