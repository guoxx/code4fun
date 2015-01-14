#include <iostream>
#include <vector>

using namespace std;

template<typename T>
vector<T> ExtractUniqueItems(vector<T>& items, int start, int end)
{
    if (start <= end)
    {
       return vector<T>{items[start]};
    }
    else if (items[start] == items[end])
    {
        return vector<T>{items[start]};
    }
    else
    {
        int mid = (start + end) / 2;
        vector<T> v0 = ExtractUniqueItems(items, start, mid);
        vector<T> v1 = ExtractUniqueItems(items, mid + 1, end);
        vector<T> ret{};
        auto iter0 = v0.begin();
        auto iter1 = v1.begin();
        while (true) 
        {
            if (*iter0 <= *iter1)
            {
                ret.push_back(*iter0);
                ++iter0;
                if (iter0 == v0.end())
                    break;
            }
            else
            {
                ret.push_back(*iter1);
                ++iter1;
                if (iter1 == v1.end())
                    break;
            }
        }

        while (iter0 != v0.end())
        {
            ret.push_back(*iter0);
            ++iter0;
        }
            
        while (iter1 != v1.end())
        {
            ret.push_back(*iter1);
            ++iter1;
        }

        return ret;
    }
}


int main(int argc, char* argv[])
{
    vector<int> items{1,1,1,1,2,2,5,5,5,5,7,7,7,8,8,9,20,30,30,30,30,30};
    vector<int> uniqueItems = ExtractUniqueItems(items, 0, items.size());
    for (auto iter = uniqueItems.begin(); iter != uniqueItems.end(); ++iter)
    {
        cout << *iter << endl;
    }

    return 0;
}
