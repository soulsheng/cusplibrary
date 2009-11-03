#include <unittest/unittest.h>
#include <cusp/ell_matrix.h>

template <class Space>
void TestEllPatternBasicConstructor(void)
{
    cusp::ell_pattern<int, Space> pattern(3, 2, 6, 2, 4);

    ASSERT_EQUAL(pattern.num_rows,              3);
    ASSERT_EQUAL(pattern.num_cols,              2);
    ASSERT_EQUAL(pattern.num_entries,           6);
    ASSERT_EQUAL(pattern.column_indices.num_cols,    2);
    ASSERT_EQUAL(pattern.column_indices.num_rows,    4);
    ASSERT_EQUAL(pattern.column_indices.num_entries, 8);
}
DECLARE_HOST_DEVICE_UNITTEST(TestEllPatternBasicConstructor);

template <class Space>
void TestEllPatternCopyConstructor(void)
{
    cusp::ell_pattern<int, Space> pattern(3, 2, 6, 2, 4);

    pattern.column_indices.values[0] = 0;
    pattern.column_indices.values[1] = 0;
    pattern.column_indices.values[2] = 0;
    pattern.column_indices.values[4] = 0;
    pattern.column_indices.values[3] = 1;
    pattern.column_indices.values[5] = 1;
    pattern.column_indices.values[6] = 1;
    pattern.column_indices.values[7] = 1;

    cusp::ell_pattern<int, Space> copy_of_pattern(pattern);
    
    ASSERT_EQUAL(copy_of_pattern.num_rows,              3);
    ASSERT_EQUAL(copy_of_pattern.num_cols,              2);
    ASSERT_EQUAL(copy_of_pattern.num_entries,           6);
    ASSERT_EQUAL_QUIET(copy_of_pattern.column_indices, pattern.column_indices);
}
DECLARE_HOST_DEVICE_UNITTEST(TestEllPatternCopyConstructor);

template <class Space>
void TestEllMatrixBasicConstructor(void)
{
    cusp::ell_matrix<int, float, Space> matrix(3, 2, 6, 2, 4);

    ASSERT_EQUAL(matrix.num_rows,              3);
    ASSERT_EQUAL(matrix.num_cols,              2);
    ASSERT_EQUAL(matrix.num_entries,           6);
    ASSERT_EQUAL(matrix.column_indices.num_cols,    2);
    ASSERT_EQUAL(matrix.column_indices.num_rows,    4);
    ASSERT_EQUAL(matrix.column_indices.num_entries, 8);
    ASSERT_EQUAL(matrix.values.num_cols,    2);
    ASSERT_EQUAL(matrix.values.num_rows,    4);
    ASSERT_EQUAL(matrix.values.num_entries, 8);
}
DECLARE_HOST_DEVICE_UNITTEST(TestEllMatrixBasicConstructor);

template <class Space>
void TestEllMatrixCopyConstructor(void)
{
    cusp::ell_matrix<int, float, Space> matrix(3, 2, 6, 2, 4);

    matrix.column_indices.values[0] = 0;  matrix.values.values[0] = 0; 
    matrix.column_indices.values[1] = 0;  matrix.values.values[1] = 1;
    matrix.column_indices.values[2] = 0;  matrix.values.values[2] = 2;
    matrix.column_indices.values[3] = 0;  matrix.values.values[4] = 3;
    matrix.column_indices.values[4] = 1;  matrix.values.values[3] = 4;
    matrix.column_indices.values[5] = 1;  matrix.values.values[5] = 5;
    matrix.column_indices.values[6] = 1;  matrix.values.values[6] = 6;
    matrix.column_indices.values[7] = 1;  matrix.values.values[7] = 7;

    cusp::ell_matrix<int, float, Space> copy_of_matrix(matrix);
    
    ASSERT_EQUAL(copy_of_matrix.num_rows,              3);
    ASSERT_EQUAL(copy_of_matrix.num_cols,              2);
    ASSERT_EQUAL(copy_of_matrix.num_entries,           6);
    ASSERT_EQUAL_QUIET(copy_of_matrix.column_indices, matrix.column_indices);
    ASSERT_EQUAL_QUIET(copy_of_matrix.values,         matrix.values);
}
DECLARE_HOST_DEVICE_UNITTEST(TestEllMatrixCopyConstructor);

template <class Space>
void TestEllMatrixSwap(void)
{
    cusp::ell_matrix<int, float, Space> A(1, 2, 2, 2, 1);
    cusp::ell_matrix<int, float, Space> B(3, 1, 3, 1, 3);

    A.column_indices.values[0] = 0;  A.values.values[0] = 0; 
    A.column_indices.values[1] = 1;  A.values.values[1] = 1;
    
    B.column_indices.values[0] = 0;  B.values.values[0] = 0; 
    B.column_indices.values[1] = 0;  B.values.values[1] = 1;
    B.column_indices.values[2] = 0;  B.values.values[2] = 2;
    
    cusp::ell_matrix<int, float, Space> A_copy(A);
    cusp::ell_matrix<int, float, Space> B_copy(B);

    A.swap(B);

    ASSERT_EQUAL(A.num_rows,              3);
    ASSERT_EQUAL(A.num_cols,              1);
    ASSERT_EQUAL(A.num_entries,           3);
    ASSERT_EQUAL_QUIET(A.column_indices, B_copy.column_indices);
    ASSERT_EQUAL_QUIET(A.values,         B_copy.values);
    
    ASSERT_EQUAL(B.num_rows,              1);
    ASSERT_EQUAL(B.num_cols,              2);
    ASSERT_EQUAL(B.num_entries,           2);
    ASSERT_EQUAL_QUIET(B.column_indices, A_copy.column_indices);
    ASSERT_EQUAL_QUIET(B.values,         A_copy.values);
}
DECLARE_HOST_DEVICE_UNITTEST(TestEllMatrixSwap);

template <class Space>
void TestEllMatrixResize(void)
{
    cusp::ell_matrix<int, float, Space> matrix;
    
    matrix.resize(3, 2, 6, 2, 4);

    ASSERT_EQUAL(matrix.num_rows,              3);
    ASSERT_EQUAL(matrix.num_cols,              2);
    ASSERT_EQUAL(matrix.num_entries,           6);
    ASSERT_EQUAL(matrix.column_indices.num_cols,    2);
    ASSERT_EQUAL(matrix.column_indices.num_rows,    4);
    ASSERT_EQUAL(matrix.column_indices.num_entries, 8);
    ASSERT_EQUAL(matrix.values.num_cols,    2);
    ASSERT_EQUAL(matrix.values.num_rows,    4);
    ASSERT_EQUAL(matrix.values.num_entries, 8);
}
DECLARE_HOST_DEVICE_UNITTEST(TestEllMatrixResize);

void TestEllPatternRebind(void)
{
    typedef cusp::ell_pattern<int, cusp::host_memory>      HostPattern;
    typedef HostPattern::rebind<cusp::device_memory>::type DevicePattern;

    HostPattern   h_pattern(10,10,100,10,10);
    DevicePattern d_pattern(h_pattern);

    ASSERT_EQUAL(h_pattern.num_entries, d_pattern.num_entries);
}
DECLARE_UNITTEST(TestEllPatternRebind);

void TestEllMatrixRebind(void)
{
    typedef cusp::ell_matrix<int, float, cusp::host_memory> HostMatrix;
    typedef HostMatrix::rebind<cusp::device_memory>::type   DeviceMatrix;

    HostMatrix   h_matrix(10,10,100,10,10);
    DeviceMatrix d_matrix(h_matrix);

    ASSERT_EQUAL(h_matrix.num_entries, d_matrix.num_entries);
}
DECLARE_UNITTEST(TestEllMatrixRebind);

