///
/// @file   mat.h
/// @author 
/// @date   Fri Sep 12 14:06:47 2008
/// 
/// @brief  Header of the Matrix class
/// 
/// 
///

#ifndef MAT_H
#define MAT_H

#include <cstring>

/// \class Mat 
///
/// \brief the matrix class
///
/// This is an empty class. You have to design you own Matrix class by
/// adding necessary data and public functions. \n
///
/// To facilliate the stamping process, the matrix class needs to satisfy 
/// the following condition:
/// - Dynamic allocation of the memory according to the size of the circuit.
/// - Expandable. Each time we stamp an element, the entries of the matrix may grow.
/// - Flexible and efficient. Most of the entries in the matrix would be zero and we don't need to store them. 
///
/// My advice is: Using orthogonal list data structure. \n
///
/// Currently, this class is designed as a C++ template. If you're not familliar with 
/// the concept of template. Just define a non-template class and do the same thing.
template<class T>
class Mat{
public:

  /// \brief Constructor
  /// \param nrow #rows
  /// \param ncol #columns
  ///
  /// \todo Allocate the memory with given size of the matrix
  Mat(int nrow, int ncol) :_row(nrow),_col(ncol) {
    
  }


  /// \brief Destructor
  ///
  /// \todo release the allocated memory
  ~Mat(){
    
  }
  
  /// \brief return #rows
  /// \return #rows
  int row() const {return _row;}

  /// \brief return #columns
  /// \return #columns
  int column() const {return _col;}
private:
  
  /// \brief #rows
  int _row;
  /// \brief #columns
  int _col;
};




typedef Mat<double> Matrix;


#endif
