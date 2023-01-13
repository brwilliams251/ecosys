/******************************************************************************
 * Copyright (c) 2016, TigerGraph Inc.
 * All rights reserved.
 * Project: TigerGraph Query Language
 *
 * - This library is for defining struct and helper functions that will be used
 *   in the user-defined functions in "ExprFunctions.hpp". Note that functions
 *   defined in this file cannot be directly called from TigerGraph Query scripts.
 *   Please put such functions into "ExprFunctions.hpp" under the same directory
 *   where this file is located.
 *
 * - Please don't remove necessary codes in this file
 *
 * - A backup of this file can be retrieved at
 *     <tigergraph_root_path>/dev_<backup_time>/gdk/gsql/src/QueryUdf/ExprUtil.hpp
 *   after upgrading the system.
 *
 ******************************************************************************/

#ifndef EXPRUTIL_HPP_
#define EXPRUTIL_HPP_

#define asd xx

#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <gle/engine/cpplib/headers.hpp>

#include <cstring>
#include <cstdio>

typedef std::string string; //XXX DON'T REMOVE

/*
 * Define structs that used in the functions in "ExprFunctions.hpp"
 * below. For example,
 *
 *   struct Person {
 *     string name;
 *     int age;
 *     double height;
 *     double weight;
 *   }
 *
 */

// a sample struct for testing
struct SampleScores {
  double sum;
  long count;

  SampleScores() : sum(0.0), count(0) {
  }

  SampleScores operator+(double score) {
    SampleScores ret;
    ret.sum = score + this->sum;
    ret.count = 1 + this->count;
    return ret;
  }
};

#endif /* EXPRUTIL_HPP_ */

inline void tg_write_file_util(std::string path) {
    int c;
    FILE *fp;
    fp = fopen(path.c_str(), "w");
    char str[20] = "Hello World!";
    if (fp)
    {
        for(int i=0; i<strlen(str); i++)
            putc(str[i],fp);
    }
    fclose(fp);
}

