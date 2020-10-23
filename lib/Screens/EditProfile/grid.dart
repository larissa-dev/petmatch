import 'dart:async';
import 'dart:io';

class GridImage {
  Future<File> imageFile;
  String url;
  GridImage({this.imageFile, this.url});
}

class DataListBuilder {
  List<GridImage> gridData = new List<GridImage>();

  GridImage row1 = new GridImage(
    imageFile: null,
    url: null,
  );
  GridImage row2 = new GridImage(
    imageFile: null,
    url: null,
  );
  GridImage row3 = new GridImage(
    imageFile: null,
    url: null,
  );
  GridImage row4 = new GridImage(
    imageFile: null,
    url: null,
  );
  GridImage row5 = new GridImage(
    imageFile: null,
    url: null,
  );
  GridImage row6 = new GridImage(
    imageFile: null,
    url: null,
  );
  GridImage row7 = new GridImage(
    imageFile: null,
    url: null,
  );

  DataListBuilder() {
    gridData.add(row1);
    gridData.add(row2);
    gridData.add(row3);
    gridData.add(row4);
    gridData.add(row5);
    gridData.add(row6);
    gridData.add(row7);
  }
}
