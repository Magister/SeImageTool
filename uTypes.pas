unit uTypes;

interface

uses
 ImagingClasses, Graphics;

type
 //Generic arrays
 TmByteArray=array of Byte;
 TIntegerArray=array of integer;
 TColorArray=array of TColor;

 //Returned when loading firmware
 TResData=record
  iRes:integer;
  sRes:string;
  PByteRes:PByte;
 end;

 //Image types
 TImgType=(imPNG,imPKI,imBWI,imUNK,imColor,imBMP);

 //Firmware image
 TfwImg=record
  imType:TImgType; //Type
  name:string; //Name
  orig_offset:integer; //Original offset, NEVER changed
  StartOffset:integer; //Start offset, changed while placing images
  Space:integer; //Space, which image occupies
  Used:integer; //Used bytes, always (?) equal to Space
  Image:TSingleImage; //Image data, for displaing. Filled on first draw
  RAWData:TmByteArray; //RAW image data, filled only for replaced images
  deleted:boolean;
  replaced:boolean;
  DisplayName:string; //Display name
  im_width:integer; //Image width
  im_height:integer; //Image height
  im_width_space:integer; //Horz. space for image
  im_height_space:integer; //Vert. space for image
  //Color db2010 data
  bp:byte;
  bt:byte;
  transp:byte;
  pal_sz:byte;
  transp_sz:byte;
 end;

 //Array of firmware images
 TfwImagesArray=array of TfwImg;

 //Changed image, used while placing images
 TChangedImage=record
  //Actually image
  fwImg:TfwImg;
  //Indexes of images if full list, which will be replaced by this one
  Indexes:TIntegerArray;
 end;

 //Array of changed images
 TChangesImages=array of TChangedImage;

 //Image table
 TImgTable=record
  Images:TfwImagesArray; //Images
  tableStart:integer; //Start offset
  pheader:integer; //Header start
  numIcons:integer; //Count of icons
  offset:integer;
  picbase:integer; //Base offset for pictures
  names:integer; //Offset for names
  offsettable:integer; //Start of table with image offsets
  table_size:integer; //Size of image table
 end;

 //Array of image tables
 TImgTables=array of TImgTable;

 //Free block
 TFreeBlock=record
  StartOffset:integer;
  Length:integer;
 end;

 //Array of free blocks
 TFreeBlocks=array of TFreeBlock;

 //For displaing of operation progress to user
 TProgressProc=procedure(Text:string;percent:integer;LogMsg:string='');

 //PIT
 TPit=record
  StartAddress:integer;
  imTables:TImgTables;
 end;

implementation

end.
