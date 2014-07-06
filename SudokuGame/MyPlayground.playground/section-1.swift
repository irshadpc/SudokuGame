import Foundation

var array = [1,2,3,4] - [2,4];
var other = array;

var result = array.filter{ $0 == 1 };

result[0] = 3;
array
