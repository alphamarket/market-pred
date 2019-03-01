#include "inc/data.hpp"
#include <boost/algorithm/string.hpp>

tuple<Data::Vector2D<double>, vector<string>> Data::CSV::load(const string& file) {
  cout << "Reading data file `" << file << "`";
  ifstream _file(file.c_str());
  string str;
  vector<size_t> IDX;
  vector<double> _temp_d;
  vector<string> _temp_s, titles;
  vector<vector<double>> collection;
  // read titles
  getline(_file, str);
  boost::trim_if(str, boost::is_any_of("\r\t "));
  boost::split(_temp_s, str, boost::is_any_of(","), boost::token_compress_on);
  // fetch the index of interested titles
  for(auto tit : { "<FIRST>", "<HIGH>", "<LOW>", "<VALUE>", "<VOL>", "<LAST>" })
    IDX.push_back(distance(_temp_s.begin(), std::find(_temp_s.begin(), _temp_s.end(), tit)));
  // fetch the related titles of the indices
  for(auto idx : IDX) titles.push_back(_temp_s[idx]);
  // for each other lines
  while(getline(_file, str)) {
    _temp_d.clear();
    boost::trim_if(str, boost::is_any_of("\r\t "));
    boost::split(_temp_s, str, boost::is_any_of(","), boost::token_compress_on);
    // get the data of the interested columns
    for(auto idx : IDX) _temp_d.push_back(stod(_temp_s[idx]));
    // add to the collection
    collection.push_back(_temp_d);
  }
  cout << " [DONE]" << endl;
  // return the values
  return { collection, titles };
}
