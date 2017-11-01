#!/bin/bash
virsh secret-define --file secret.xml
virsh secret-set-value --secret $(cat uuid-secret.txt) --base64 $(cat client.cinder.key)

