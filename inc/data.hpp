#ifndef LOADCSV_HPP
#define LOADCSV_HPP

#include "stdafx.hpp"

namespace Data {
  template<class T>
  using Vector2D = vector<vector<T>>;

  template<class T, size_t IN, size_t OUT>
  struct Dataset {
    const size_t
      input_size = IN,
      output_size = OUT;
    T* inputs;
    T* targets;
    Dataset(T inputs[IN], T targets[OUT])
    {
      this->inputs = new T[IN];
      this->targets = new T[OUT];
      this->inputs = inputs;
      this->targets = targets;
    }

    ~Dataset() {
      delete[] inputs;
      delete[] targets;
    }
  };

  template<class T, size_t IN, size_t OUT>
  using Database = vector<Dataset<T, IN, OUT>*>;

  template<class T, size_t IN, size_t OUT>
  using SuperDatabase = vector<Database<T, IN, OUT>*>;

  class CSV {
  public:
    static tuple<Vector2D<double>, vector<string>> load(const string&);
  };
}

#endif // LOADCSV_HPP
