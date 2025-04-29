function changeCurrentFolderToScriptFolder(verbose)
    % cdToScriptDir - 将当前工作目录切换到调用此函数的脚本或函数所在目录
    %
    % 输入参数:
    %   verbose - (可选) 布尔值，是否显示切换后的目录路径，默认 false
    %
    % 用法:
    %   在你的脚本中调用 cdToScriptDir()，即可将工作目录切换到该脚本所在的文件夹。

    if nargin < 1
        % verbose = false;
        verbose = true;
    end

    % 获取调用栈信息，跳过当前函数
    stack = dbstack(1);
    scriptFolder = '';

    if isempty(stack)
        scriptFolder = pwd;
        if verbose
            disp('The call stack is empty, using the current directory as the working directory.');
        end
    else
        % 获取调用者的文件路径
        callerFile = stack(1).file;
        if verbose
            disp(['Caller File is ', callerFile]);
        end
        
        if isempty(callerFile)
            scriptFolder = pwd;
            if verbose
                disp('The caller file is empty, using the current directory as the working directory.');
            end
        else
            % 如果 callerFile 只包含文件名，使用 which 获取完整路径
            if ~contains(callerFile, filesep) % 检查是否缺少路径分隔符
                fullCallerFile = which(callerFile);
                if isempty(fullCallerFile)
                    scriptFolder = pwd;
                    if verbose
                        disp('The caller file is not found, using the current directory as the working directory.');
                    end
                else
                    callerFile = fullCallerFile;
                    if verbose
                        disp(['The callerFile is : ', callerFile]);
                    end
                end
            end
            
            % 使用 fileparts 解析目录
            [scriptFolder, ~, ~] = fileparts(callerFile);
            if verbose
                disp(['Folders: ', scriptFolder]);
            end
            
            if isempty(scriptFolder)
                scriptFolder = pwd;
                if verbose
                    disp('The script folder is empty, using the current directory as the working directory.');
                end
            end
        end
    end

    % 切换当前工作目录
    if ~isempty(scriptFolder)
        try
            cd(scriptFolder);
            if verbose
                disp(['change to current folder successfully: ', scriptFolder]);
            end
        catch ME
            warning('Cannot change to folder "%s": .Holder the folder.', scriptFolder, ME.message);
            scriptFolder = pwd;
        end
    else
        scriptFolder = pwd;
        if verbose
            disp('The script folder is empty, using the current directory as the working directory.');
    end

    if verbose
        disp(['Current folder: ', pwd]);
    end
end