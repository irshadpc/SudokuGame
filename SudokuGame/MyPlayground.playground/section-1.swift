import CoreGraphics

var myDouble = 2.0
var myInt = 2;

Int(myDouble) == myInt

myDouble > Double(myInt)

func array<T: Equatable>(array:T[], contains other:T[]) -> Bool{
    var mutable = other;
    for element in array{
        for (index, agent) in enumerate(mutable){
            if(element == agent){
                mutable.removeAtIndex(index);
            }
        }
        if(mutable.count == 0){ return true; }
    }
    return false;
}



func findIndex<T: Equatable>(array: T[], valueToFind: T) -> Int? {
    for (index, value) in enumerate(array) {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

var first = [1,2,3,4,5,6,7,8,9,10,11];
var second = [1,4,11,0];
var result = Int[]();


array(first, contains: second);

for firstElement in first{
    for (index, secondElement) in enumerate(second){
        if(firstElement == secondElement){
            second.removeAtIndex(index)
            result.append(secondElement);
        } 
    }
}

result
second

var iterations = 0;
var result2 = first.filter({
    for (index, element) in enumerate(result){
        if($0 == element){
            iterations++;
            return true;
        }
    }
    iterations++;
    return false;
})

iterations
