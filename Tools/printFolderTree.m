function printFolderTree(rootDir, indent)
    if nargin < 2
        indent = '';
    end

    % 获取当前目录下的所有条目
    entries = dir(rootDir);
    entries = entries(~ismember({entries.name}, {'.', '..'})); % 忽略 . 和 ..
    entries = entries([entries.isdir]); % 仅处理文件夹（若需文件，删除此行）

    for i = 1:length(entries)
        entry = entries(i);
        isLast = (i == length(entries));

        % 打印当前条目名称
        if isLast
            fprintf('%s└── %s\n', indent, entry.name);
            nextIndent = [indent '    '];
        else
            fprintf('%s├── %s\n', indent, entry.name);
            nextIndent = [indent '│   '];
        end

        % 递归子目录
        fullPath = fullfile(rootDir, entry.name);
        printFolderTree(fullPath, nextIndent);
    end
end