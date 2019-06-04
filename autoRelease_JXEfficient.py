# -*- coding: utf-8 -*-
import os
import sys
import re

if sys.getdefaultencoding() != 'utf-8':
    reload(sys)
    sys.setdefaultencoding('utf-8')

#

project_path = "%s/Desktop/GitHub/JXEfficient" % os.environ['HOME']

proj_name = "JXEfficient"
pod_Spec_Repo = "JXSpecRepo"


log_pre_success = "✅ =====>"
log_pre_failure = "❌ =====>"


# 增加组件版本号
def add_version():
    os.chdir("%s" % project_path)

    # 获取当前 仓库 的最新版本
    tag_old = os.popen("git describe --tags `git rev-list --tags --max-count=1`").read().replace("\n", "")
    print(tag_old)

    # 检查本地仓库是否修改
    status = os.popen("git status").read()
    if "nothing to commit" in status:
        print("%s %s" % (log_pre_failure, status))
        print("tab_old %s" % (tag_old))
        return

    ver_components = tag_old.split('.')
    ver_components[-1] = str(int(ver_components[-1]) + 1)
    tag_new = '.'.join(ver_components)
    print(tag_new)

    # 修改组件配置文件版本号
    filePath = "%s/%s.podspec" % (project_path, proj_name)
    open_r = open(filePath, 'r')
    content = open_r.read()
    
    open_r = open(filePath, 'r')
    lines = open_r.readlines()

    # 替换版本
    for line in lines:
        if 's.version' in line:
            local_version = re.findall(r'\'(.*)\'', line)[0]
            content = content.replace(local_version, tag_new)
            break

    # 回写文件
    open_w = open(filePath, 'w')
    open_w.write(content)
    open_w.close()

    #
    push_git(tag_new)

#
def push_git(tag_new):
    # 提交当前修改
    os.chdir("%s" % project_path)
    os.system("git add -A")
    status = os.popen("git commit -m \"push by %s\"" % os.path.basename(__file__)).read()
    if "nothing to commit" in status:
        return
    print(status)

    # 创建 tag
    os.system("git push")
    os.system("git tag %s" % (tag_new))
    os.system("git push --tags")

    #
    pod_repo_push()

#
def pod_repo_push():
    # 发布组件版本
    # os.system("pod repo push %s %s.podspec --allow-warnings --verbose --sources=\'git@gitee.com:codersun/JXSpecRepo.git, https://github.com/CocoaPods/Specs.git\'" % (pod_Spec_Repo, proj_name))
    # os.system("pod repo push %s %s.podspec --allow-warnings --verbose" % (pod_Spec_Repo, proj_name))

    # github
    os.system("pod trunk push %s.podspec --allow-warnings --verbose" % (proj_name))
#
def main():
    add_version()



#
main()

