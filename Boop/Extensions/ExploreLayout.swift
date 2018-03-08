import UIKit

class ExploreLayout: UICollectionViewFlowLayout {
    
    fileprivate var numberOfColumns = 3;
    fileprivate var numberOfRows = 2;
    
    var size: CGSize? = nil;
    var cache: [[UICollectionViewLayoutAttributes]] = [];
    var max:CGFloat = 0;
    
    convenience init(size: CGSize){
        self.init();
        self.size = size;
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: max+15, height: size!.height);
    }
    override func prepare() {
        // 1. Only calculate once
       /* guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }*/
        
        let padding: CGFloat = 15;
        
        self.scrollDirection = .horizontal;
        for section in 0 ..< collectionView!.numberOfSections{
            
            var sectionArr: [UICollectionViewLayoutAttributes] = [];
            let columnWidth = (size!.width/CGFloat(numberOfColumns));
            //let actualWidth = (size!.width-(padding*2)-(padding*(CGFloat(numberOfColumns))))/CGFloat(numberOfColumns);
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                
                var xSize = (self.size!.width)
                xSize = (xSize * CGFloat(section));
                xSize = xSize + (CGFloat(column) * columnWidth);
                
               if(column == 0){
                    xSize = xSize+15;
               }
               else if(column == numberOfColumns-1){
                    //xSize = xSize-15;
               }
               else{
                    xSize = xSize+(15/2)
                }
                
                if(xSize+columnWidth > max){
                    max = xSize+columnWidth-15;
                }
                xOffset.append(xSize);
            }
            
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                let height = (size!.height/2)-padding
                
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth-15, height: height)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                sectionArr.append(attributes)
                yOffset[column] = yOffset[column] + height + 15
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
            
            cache.append(sectionArr);
            
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        var debugO = 0;
        var debugP = 0;
        for section in cache {
            for attributes in section{
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
                debugP = debugP+1;
            }
            debugP = 0;
            debugO = debugO+1;
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.section][indexPath.item]
    }
    
}
