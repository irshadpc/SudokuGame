struct TileIndex{
    var row: Int
    var column: Int
    
    func toInt() -> Int{
        return (row == 1) ? (column-1) : ((row-1) * 8) + column;
    }
}

var index = TileIndex(row: 2, column: 3)

var result = index.toInt();