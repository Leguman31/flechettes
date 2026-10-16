# Assemble index.html à partir de la page de l'artifact
import sys
s=open(sys.argv[1]).read()
h='''<!doctype html>
<html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no,viewport-fit=cover">
<meta name="theme-color" content="#121512"><link rel="manifest" href="manifest.json"><link rel="icon" href="icon-192.png">
<link rel="apple-touch-icon" href="icon-192.png"><meta name="apple-mobile-web-app-capable" content="yes"><meta name="apple-mobile-web-app-status-bar-style" content="black">
'''
t='''
<script>if('serviceWorker'in navigator&&location.protocol.startsWith('http'))navigator.serviceWorker.register('sw.js').catch(()=>{})</script>
</html>
'''
open('index.html','w').write(h+s+t)
