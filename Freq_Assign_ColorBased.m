%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% COG Algorithm %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ret_assignment=Freq_Assign_ColorBased(WE,curr_assignment,ratio)
    
    % �ĺ����ļ��� ����; �߿����� ����
    N_freq=40000;
    
    % ��Ÿ�ũ�� ����
    N_link=size(curr_assignment,2);
    
    % ����ȭ �� �ʿ� ���ļ� �̰ݷ�
    WE_dist=Atten(WE);
    
    % �� ��ũ�� ������ ���� (��=1,2,3,4,...)
    Freq_00=Coloring(WE,zeros(1,N_link));
 
    % ���ļ� ����, �������� ��ũ ���� ratio���� �۾��� ������
    % ratio=0�̸� COG �˰����� �ȴ�.
    % Main board���� 0���� ū ratio���� �Է��Ͽ� �� �ڵ带 �����ϰ� ��� ���� HEDGE �ڵ忡 �Է� ������ ������ Hybrid �˰����� �ȴ�.
    while size(find(curr_assignment==0),2)>ratio
        Candidate=1:N_freq;
        %rem=size(find(curr_assignment==0),2);
        %fprintf('%d remained\n',rem);
 
        %%%% Ordering
        % unassigned : �������� ���� ��ũ���
        unassigned=find(curr_assignment==0);
        % list2 : �� �� �ּ��� �� ��ȣ�� ���� ��ũ��� 
        list2=find(Freq_00(unassigned)==min(Freq_00(unassigned)));
        % turn : �ش� �� ��ȣ�� ���� ��ũ�鿡�� ���ļ��� �������� '����'�� ���ƿ´�
        turn=unassigned(list2);
        ret=size(turn,2);
        
        % set_freq : ���� �����Ǿ� �ִ� ���ļ� �ѹ� ��� (1,3,3,1,4 -> 1,3,4)
        set_freq=unique(curr_assignment);
        
        %%%% Decide the candidates
        % ���ʰ� �� ��ũ�鿡 ������ �� �ִ� ���ļ� �ĺ����� �߸��� ����
        for jj=1:ret
            for ii=1:N_link
                % tmp_dist : ii��° ��ũ�� ���� ������ ��ũ�� ������ �Ÿ��� �� �ִ� (���ļ� �̰ݰŸ�)
                tmp_dist=max(WE_dist(ii,turn(jj)),WE_dist(turn(jj),ii));
                if tmp_dist>0
                    if curr_assignment(ii)~=0
                        % �Ÿ��� 0���� ũ�� ii��° ��ũ�� �̹� ������ ���ļ��� �����Ѵٸ�
                        % �� ���ļ��κ��� �̰ݰŸ���ŭ �� �Ʒ��� ����Ʈ�� ������ ���ļ� �ĺ������� �����Ѵ�.

                        % Candidate�� 1,2,3,4,...,N�� �����Ǿ��ְ� curr_assignment=4, tmp_dist=1�̶�� 
                        % 1,2,3N,3N,3N,...,N���� ��ȯ�Ǵµ� ���� �� �� �ּڰ��� �����ϴ�
                        % ������� 4�κ��� 1�� �Ÿ� �̳��� �ִ� ���ļ����� �ĺ����� �����Ѵ�.

                        % max(1,curr_assignment(ii)-tmp_dist+1) : curr_assignment = 2,
                        % tmp_dist = 4��� -2~6�� ���ļ��� �ĺ����� �����ؾ� �ϴµ� -2~0�� ���ļ���
                        % invalid�ϹǷ� max�� ���� 1~6���� �����Ѵ�. min�� ��������.
                        Candidate(max(1,curr_assignment(ii)-tmp_dist+1):min(curr_assignment(ii)+tmp_dist-1,N_freq))=3*N_freq;
                    end
                end
            end
        end
        
        %%%% Assign the frequencies
        if size(nonzeros(set_freq),1)==0
            % �������� ���ļ��� ���ٸ� �߷��� �ĺ��� �� �ּڰ��� ����
            curr_assignment(turn)=min(Candidate);
        else
            % �ִٸ� �̹� ���� ���ļ� �� �ĺ����� ���ϴ� ���ļ��� �ִ��� Ž��
            freq_tmp=intersect(set_freq,Candidate);
            if size(freq_tmp,2)==0
                % ���ٸ� �ĺ��� �� �ּڰ��� ����
                curr_assignment(turn)=min(Candidate); clear freq_tmp;
            else
                % �ִٸ� ������ ���ļ��� �ĺ����� ������ �� �ּڰ��� ����
                curr_assignment(turn)=min(freq_tmp);
                clear freq_tmp;
            end
        end
    end
    ret_assignment=curr_assignment;
end


