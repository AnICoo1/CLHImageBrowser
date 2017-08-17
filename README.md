# CLHImageBrowser
一个简便的图片浏览器

* 使用方法
    * 加载本地图片
    
    ```
    let imageBrowser = CLHPhotoBrowser(frame: CGRect(x: 50, y: 200, width: 250, height: 100))
    imageBrowser.imageDataArrayFromLocal = ["3", "4", "5"]
    view.addSubview(imageBrowser)
    imageBrowser.show()
    ```
    * 加载网络图片
    ```
    let imageBrowser = CLHPhotoBrowser(frame: CGRect(x: 50, y: 200, width: 250, height: 100))
    imageBrowser.imageDataArrayFromURL = ["http://www.quentinroussat.fr/assets/img/iOS%20icon's%20Style/ios8.png", "http://www.quentinroussat.fr/assets/img/iOS%20icon's%20Style/ios8.png", "http://www.quentinroussat.fr/assets/img/iOS%20icon's%20Style/ios8.png"]
    view.addSubview(imageBrowser)
    imageBrowser.show()
    ```
    二者可混合使用

* 效果如下

![image](https://github.com/AnICoo1/CLHImageBrowser/blob/master/imageBrowser.gif)
