#!/usr/bin/env python3
# ==============================================================================
# QD-Today Ingress 路径适配器
# 在 Tornado 启动前注入，使 self.redirect() 自动添加 Ingress 路径前缀。
# 用法: python3 /usr/local/bin/qd_ingress_wrapper.py
# ==============================================================================
import os
import sys

ingress_path = os.environ.get('INGRESS_PATH', '').rstrip('/')

if ingress_path:
    import tornado.web
    _original_redirect = tornado.web.RequestHandler.redirect

    def _ingress_redirect(self, url, permanent=False, status=None):
        if url.startswith('/') and not url.startswith(ingress_path + '/'):
            url = ingress_path + url
        return _original_redirect(self, url, permanent=permanent, status=status)

    tornado.web.RequestHandler.redirect = _ingress_redirect

sys.path.insert(0, '/usr/src/app')
os.chdir('/usr/src/app')

# 直接 exec run.py 的 __main__ 逻辑
run_py = os.path.join('/usr/src/app', 'run.py')
with open(run_py, 'rb') as f:
    code = compile(f.read(), run_py, 'exec')
exec(code, {'__name__': '__main__'})
