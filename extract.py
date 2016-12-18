#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
import re

def get_province(text,web):
    output=web+";"
    province_list=["Beijing","Shenzhen","Inner Mongolia","Heilongjiang Province","Yunnan Province"]
    for province in province_list:
        rex = re.compile(province+'</td></td><td class="resultstatus.*?</td>',re.S|re.M)
        match=rex.findall(text)
        if len(match)>0:
            status=match[0].split('">')[1].split("<")[0]
            output+="%s;" % status
        else:
            output+="-;"
    return output


if __name__ == "__main__":
    with open(sys.argv[1] ,"r") as fp:
        text=fp.read()
        print get_province(text,sys.argv[2])
