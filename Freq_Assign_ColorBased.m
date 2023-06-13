%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% COG Algorithm %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ret_assignment=Freq_Assign_ColorBased(WE,curr_assignment,ratio)
    
    % 후보주파수의 개수; 중요하지 않음
    N_freq=40000;
    
    % 통신링크의 개수
    N_link=size(curr_assignment,2);
    
    % 양자화 된 필요 주파수 이격량
    WE_dist=Atten(WE);
    
    % 각 링크에 색깔을 배정 (색=1,2,3,4,...)
    Freq_00=Coloring(WE,zeros(1,N_link));
 
    % 주파수 배정, 미지정된 링크 수가 ratio보다 작아질 때까지
    % ratio=0이면 COG 알고리즘이 된다.
    % Main board에서 0보다 큰 ratio값을 입력하여 이 코드를 실행하고 출력 값을 HEDGE 코드에 입력 값으로 넣으면 Hybrid 알고리즘이 된다.
    while size(find(curr_assignment==0),2)>ratio
        Candidate=1:N_freq;
        %rem=size(find(curr_assignment==0),2);
        %fprintf('%d remained\n',rem);
 
        %%%% Ordering
        % unassigned : 배정되지 않은 링크목록
        unassigned=find(curr_assignment==0);
        % list2 : 그 중 최소의 색 번호를 갖는 링크목록 
        list2=find(Freq_00(unassigned)==min(Freq_00(unassigned)));
        % turn : 해당 색 번호를 갖는 링크들에게 주파수를 배정받을 '차례'가 돌아온다
        turn=unassigned(list2);
        ret=size(turn,2);
        
        % set_freq : 현재 배정되어 있는 주파수 넘버 목록 (1,3,3,1,4 -> 1,3,4)
        set_freq=unique(curr_assignment);
        
        %%%% Decide the candidates
        % 차례가 된 링크들에 배정할 수 있는 주파수 후보군을 추리는 과정
        for jj=1:ret
            for ii=1:N_link
                % tmp_dist : ii번째 링크와 현재 차례의 링크들 사이의 거리들 중 최댓값 (주파수 이격거리)
                tmp_dist=max(WE_dist(ii,turn(jj)),WE_dist(turn(jj),ii));
                if tmp_dist>0
                    if curr_assignment(ii)~=0
                        % 거리가 0보다 크고 ii번째 링크에 이미 배정된 주파수가 존재한다면
                        % 그 주파수로부터 이격거리만큼 위 아래로 떨어트린 영역은 주파수 후보군에서 배제한다.

                        % Candidate는 1,2,3,4,...,N로 구성되어있고 curr_assignment=4, tmp_dist=1이라면 
                        % 1,2,3N,3N,3N,...,N으로 변환되는데 추후 이 중 최솟값을 선택하는
                        % 방식으로 4로부터 1의 거리 이내에 있는 주파수들을 후보에서 배제한다.

                        % max(1,curr_assignment(ii)-tmp_dist+1) : curr_assignment = 2,
                        % tmp_dist = 4라면 -2~6의 주파수를 후보에서 제외해야 하는데 -2~0의 주파수는
                        % invalid하므로 max를 취해 1~6으로 설정한다. min도 마찬가지.
                        Candidate(max(1,curr_assignment(ii)-tmp_dist+1):min(curr_assignment(ii)+tmp_dist-1,N_freq))=3*N_freq;
                    end
                end
            end
        end
        
        %%%% Assign the frequencies
        if size(nonzeros(set_freq),1)==0
            % 기지정된 주파수가 없다면 추려진 후보군 중 최솟값을 선택
            curr_assignment(turn)=min(Candidate);
        else
            % 있다면 이미 사용된 주파수 중 후보군에 속하는 주파수가 있는지 탐색
            freq_tmp=intersect(set_freq,Candidate);
            if size(freq_tmp,2)==0
                % 없다면 후보군 중 최솟값을 선택
                curr_assignment(turn)=min(Candidate); clear freq_tmp;
            else
                % 있다면 기지정 주파수와 후보군의 교집합 중 최솟값을 선택
                curr_assignment(turn)=min(freq_tmp);
                clear freq_tmp;
            end
        end
    end
    ret_assignment=curr_assignment;
end


