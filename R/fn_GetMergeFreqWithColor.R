#' @title wordcloud Extended application
#'
#' @description wordcloud Extended application
#'
#' @param symbol
#'
#' @return NULL
#'
#' @examples
#'
#' @export fn_GetMergeFreqWithColor
fn_GetMergeFreqWithColor=function(tb2freq3,totrectb2,tb1freq3,totrectb1,r1,g1,b1,r2,g2,b2,r3,g3,b3,MinI,MidI,MaxI,Tuning_Count)
{
  #input: target dataset--tb2freq3,reference dataset---tb1freq3
  #input: tb2freq3 record number,tb1freq3 record number
  #input: 3 RGB color,3 index
  #input: tuning for color--Tuning_Count range: 0~1~X
  #output: freq dataset with color

  Default_r1=204
  Default_g1=153
  Default_b1=2
  Default_r2=6
  Default_g2=82
  Default_b2=174
  Default_r3=232
  Default_g3=13
  Default_b3=237
  Default_MinIndex=50
  Default_MidIndex=100
  Default_MaxIndex=400

  #input:RGB dec number
  #output:HEX RGB string
  fn_GetHEXColor=function(r,g,b)
  {
    if(nchar(as.character(as.hexmode(r)))==1)
    {
      s1=paste("0",as.character(as.hexmode(r)),sep = "")
    }
    else
    {
      s1=as.character(as.hexmode(r))
    }
    if(nchar(as.character(as.hexmode(g)))==1)
    {
      s2=paste("0",as.character(as.hexmode(g)),sep = "")
    }
    else
    {
      s2=as.character(as.hexmode(g))
    }
    if(nchar(as.character(as.hexmode(b)))==1)
    {
      s3=paste("0",as.character(as.hexmode(b)),sep = "")
    }
    else
    {
      s3=as.character(as.hexmode(b))
    }
    return(paste("#",s1,s2,s3,sep = ""))
  }

  #input: midIndex, highIndex, midColor, highColor, Value
  #output: calculated Color number (higher the mid Index)
  fn_GetUpperColor=function(Index1,IndexMax,Color1,Color2,Value)
  {
    final=Color2
    if(Value<IndexMax)
    {
      final=Color1+(Color2-Color1)*(Value-Index1)/(IndexMax-Index1)
    }
    if(final>255)
    {
      final=255
    }
    if(final<0)
    {
      final=0
    }
    return(final)
  }

  #input: lowIndex, midIndex, lowColor, midColor, Value
  #output: calculated Color number (lower the mid Index)
  fn_GetLowerColor=function(IndexMin,Index2,Color1,Color2,Value)
  {
    final=Color1
    if(Value>IndexMin)
    {
      final=Color1+(Color2-Color1)*(Value-IndexMin)/(Index2-IndexMin)
    }
    if(final>255)
    {
      final=255
    }
    if(final<0)
    {
      final=0
    }
    return(final)
  }

  #input: lowColor, midColor, HighColor, lowIndex, midIndex, highIndex, Value
  #combined with all range of the index
  #output: color number
  fn_GetRGBColorCount=function(LowColor,MidColor,HighColor,mnIndex,mdIndex,mxIndex,Value)
  {

    if(Value<mdIndex)
    {
      return(round(fn_GetLowerColor(mnIndex,mdIndex,LowColor,MidColor,Value)))
    }
    else
    {
      return(round(fn_GetUpperColor(mdIndex,mxIndex,MidColor,HighColor,Value)))
    }
  }

  #input: 3 RGB 3 Index and Value
  #output: RGB string
  fn_GetColorFinal=function(Value)
  {
    R_Count=fn_GetRGBColorCount(Default_r1,Default_r2,Default_r3,Default_MinIndex,Default_MidIndex,Default_MaxIndex,Value)
    G_Count=fn_GetRGBColorCount(Default_g1,Default_g2,Default_g3,Default_MinIndex,Default_MidIndex,Default_MaxIndex,Value)
    B_Count=fn_GetRGBColorCount(Default_b1,Default_b2,Default_b3,Default_MinIndex,Default_MidIndex,Default_MaxIndex,Value)
    return(fn_GetHEXColor(R_Count,G_Count,B_Count))
  }


  finalfreq=merge(tb2freq3, tb1freq3, by="char",all.x=T)
  finalfreq$freqPer2=finalfreq$freq.x/totrectb2
  finalfreq$freqPer1=finalfreq$freq.y/totrectb1
  finalfreq$Index=finalfreq$freqPer2/finalfreq$freqPer1*100
  MinIndex=MinI^Tuning_Count
  MaxIndex=MaxI^Tuning_Count
  MidIndex=MidI^Tuning_Count
  finalfreq[is.na(finalfreq$Index),"Index"]=MaxIndex
  finalfreq$Tuning_Index=(finalfreq$Index)^Tuning_Count
  Default_r1<<-r1
  Default_g1<<-g1
  Default_b1<<-b1
  Default_r2<<-r2
  Default_g2<<-g2
  Default_b2<<-b2
  Default_r3<<-r3
  Default_g3<<-g3
  Default_b3<<-b3
  Default_MinIndex<<-MinIndex
  Default_MidIndex<<-MidIndex
  Default_MaxIndex<<-MaxIndex
  finalfreq$color <- lapply(finalfreq$Tuning_Index,function(x) unlist(fn_GetColorFinal(x)))
  return(finalfreq)
}
