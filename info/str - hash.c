int str2hash(int ptr,int strsize)
{
  int retcode,curchar,temp;

  retcode=0;
  if(ptr)
  for(;;)
  {
    curchar=DSBYTE[ptr];
    ptr+=1;

    if(!curchar)break;
    if(!strsize)break;

    if(curchar=='_')curchar=0x24;
    else
    if(curchar>='A')&&(curchar<'[')curchar+=0xC9;  //0x0A..0x23
    else
    if(curchar>='0')&&(curchar<':')curchar+=0xD0;  //0x00..0x09
    else
    if(curchar>='a')&&(curchar<'{')curchar+=0xC4;  //0x25..0x3E
    else curchar=0x3F;

    curchar &= 0x3F;
    curchar |= retcode<<6;
    temp = retcode>>0x12;
    retcode = 0x3F&temp ^ curchar;
    strsize--;
  }
  return retcode & 0xFFFFFF;
}