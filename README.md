#Playbook for deploying architecture for NaviMerch

I express great gratitude for the article and the materials provided @vkozlovski on the portal habrahabr
Some of them were used in my implementation

#origin: https://github.com/vkozlovski/ansible-cloud-hosting

#article: https://habr.com/post/277657/


#Quick start



Firstly you need to generate certificates
Run:
```
$ make gen-ca
```

*Note: You must specify your password for certificates