#!/bin/bash
grep "<loc>" public/sitemap.xml | awk -F "<loc>" '{print $2}' | awk -F '</loc>' '{print $1}' > sitemap.txt
echo -n "一共"
echo -n `cat sitemap.txt | wc -l`
echo "个网址."
curl -H 'Content-Type:text/plain' --data-binary @sitemap.txt "http://data.zz.baidu.com/urls?site=qifuguang.me&token=mjq9KjjOrJPRKr5E"
echo
echo ""提交完成
