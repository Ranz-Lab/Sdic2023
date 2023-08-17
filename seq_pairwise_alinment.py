#!/usr/bin/env python

'''
[usage] sh seq_pairwise_alinment.py  infile s1 s2 outfile
    sh seq_pairwise_alinment.py  infile s1 s2 > outfile
[purpose]
    get the score of the pairwise alinment.
'''

import sys
from Bio import pairwise2


def seq_pairwise_alinment(infile,seqcol1,seqcol2,gap_penalties,outfile,sep):
    for eachline in infile:
        tmp = eachline.strip("\n").split(sep)
        seq1 = tmp[seqcol1]
        seq2 = tmp[seqcol2]
        ###s1, s2, sc, i1, i2
        alin = pairwise2.align.globalxs(seq1,seq2,0,0)[0]
###        out_list = [s1, s2, sc, i1, i2]
###        out = sep.join(out_list)
        tmp.extend(alin)
        outfile.write(sep.join(map(str,tmp))+"\n")

def main(argv):
    import argparse
    parser = argparse.ArgumentParser(description="get the score of the pairwise alinment.")
    parser.add_argument('infile',nargs='?',help="The file contains two columns of sequences that will be pairwise alinment , \"-\" for stdin ")
    parser.add_argument('-o','--outfile',nargs='?',help="output file",default=sys.stdout,type=argparse.FileType('w'))
    parser.add_argument('-s','--sep',nargs='?',default="\t")
    parser.add_argument('-c1','--seqcol1',nargs='?',default=0,type=int)
    parser.add_argument('-c2','--seqcol2',nargs='?',default=1,type=int)
    parser.add_argument('-sm','--match_score',nargs='?',help="A match score is the score of identical chars,otherwise mismatch score.", default="1")
    parser.add_argument('-sg','--gap_penalties',nargs='?',help="Same open and extend gap penalties for both sequences.", default="0")
    args = parser.parse_args(argv[1:])
    
    sep=args.sep
    match_score=args.match_score
    gap_penalties=args.gap_penalties
    seqcol1=args.seqcol1
    seqcol2=args.seqcol2

    if args.infile == '-':
        infile=sys.stdin
    else:
        infile=open(args.infile)
    outfile=args.outfile

    seq_pairwise_alinment(infile,seqcol1,seqcol2,gap_penalties,outfile,sep)


if __name__ == '__main__':

    main(sys.argv)

