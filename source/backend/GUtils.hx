package backend;

class GUtils {
    public static function clearArray<T>(array:Array<T>, ?exFunc:(T)->Void):Array<T> {
        for (arrayObj in array){
            if (exFunc != null)
                exFunc(arrayObj);
            array.remove(arrayObj);
        }
        return array;
    }
}