function root = newtons_method(f,df,x0,opts)
    
    % ----------------------------------
    % Sets (or defaults) solver options.
    % ----------------------------------
    
    % sets maximum number of iterations (defaults to 1e6)
    if (nargin < 4) || isempty(opts) || ~isfield(opts,'imax')
        imax = 1e6;
    else
        imax = opts.imax;
    end
    
    % determines return value (defaults to only return converged root)
    if (nargin < 4) || isempty(opts) || ~isfield(opts,'return_all')
        return_all = false;
    else
        return_all = opts.return_all;
    end
    
    % sets tolerance (defaults to 1e-12)
    if (nargin < 4) || isempty(opts) || ~isfield(opts,'TOL')
        TOL = 1e-12;
    else
        TOL = opts.TOL;
    end
    
    % determines if warnings should be displayed (defaults to true)
    if (nargin < 4) || isempty(opts) || ~isfield(opts,'warnings')
        warnings = true;
    else
        warnings = opts.warnings;
    end
    
    % -----------------------------------------------
    % "Return all" implementation of Newton's method.
    % -----------------------------------------------
    
    if return_all
        
        % preallocates x
        x = zeros(imax,1);
        % inputs initial guess for root into x vector
        x(1) = x0;
        % initializes the error so the loop will be entered
        err = 2*TOL;
    
        % Newton's method
        i = 1;
        while (err > TOL) && (i < imax)
            % updates estimate of root
            x(i+1) = x(i)-f(x(i))/df(x(i));
            % calculates error
            err = abs(x(i+1)-x(i));
            % increments loop index
            i = i+1;
        end
        
        % returns converged root along with intermediate root estimates
        root = x(1:i);
    % -----------------------------------------
    % "Fast" implementation of Newton's method.
    % -----------------------------------------
    
    else
        
        % sets root estimate at the first iteration of Newton's method as 
        % the initial guess
        x_old = x0;
        
        % initializes x_new so its scope isn't limited to the while loop
        x_new = 0;
        
        % initializes the error so the loop will be entered
        err = 2*TOL;
        
        % Newton's method
        i = 1;
        while (err > TOL) && (i < imax)
            % updates estimate of root
            x_new = x_old-f(x_old)/df(x_old);
            % calculates error
            err = abs(x_new-x_old);
            % stores current root estimate for next iteration
            x_old = x_new;
            % increments loop index
            i = i+1;
        end
        
        % returns converged root
        root = x_new;
      
    end
    % ---------------------------------------------------------
    % Displays warning if maximum number of iterations reached.
    % ---------------------------------------------------------
    if (i == imax) && warnings
        warning(strcat('The method failed after i=',num2str(imax),...
            ' iterations.'));
    end
    
end