package ausstage;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author James
 * Taken from http://www.gotoquiz.com/web-coding/programming/java-programming/resize-images-in-java-preserving-image-quality/
 */
public enum ImageType {
    JPG,
    GIF,
    PNG,
    BMP,
    UNKNOWN;
    
    private static final Map<String, ImageType> extensionMap = new HashMap<String, ImageType>();
    
    static {
        extensionMap.put("jpg", ImageType.JPG);
        extensionMap.put("jpeg", ImageType.JPG);
        extensionMap.put("gif", ImageType.GIF);
        extensionMap.put("png", ImageType.PNG);
        extensionMap.put("bmp", ImageType.BMP);
    }

    public static ImageType getType(String ext) {
        ext = ext.toLowerCase();
        if (extensionMap.containsKey(ext))
            return extensionMap.get(ext);
        else
            return UNKNOWN;
    }
}
