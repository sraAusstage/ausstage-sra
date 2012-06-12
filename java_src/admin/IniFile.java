package admin;

import java.io.*;

public class IniFile
{

    public IniFile()
    {
        numnodes = 0;
        maxnodes = 50;
        cursor = 0;
        nodes = new IniFileNode[maxnodes];
        for(int i = 0; i < maxnodes; i++)
            nodes[i] = new IniFileNode();

    }

    public boolean addHeader(String name)
    {
        if(name.length() == 0)
            return false;
        int i;
        if(numnodes >= maxnodes)
        {
            IniFileNode temp[] = new IniFileNode[maxnodes + 50];
            for(i = 0; i < maxnodes; i++)
                temp[i] = nodes[i];

            for(i = maxnodes; i < maxnodes + 50; i++)
                temp[i] = new IniFileNode();

            nodes = temp;
            maxnodes += 50;
        }
        for(i = 0; i < name.length(); i++)
            if((name.charAt(i) < 'a' || name.charAt(i) > 'z') && (name.charAt(i) < 'A' || name.charAt(i) > 'Z') && (name.charAt(i) < '0' || name.charAt(i) > '9') && name.charAt(i) != ' ')
                i = name.length() + 1;

        if(i == name.length() + 1)
            return false;
        if(numnodes == 0)
        {
            nodes[numnodes].title = name;
        } else
        {
            for(i = 0; i < numnodes; i++)
                if(nodes[i].title.compareTo(name) == 0)
                {
                    cursor = i;
                    return false;
                }

            nodes[numnodes].title = name;
        }
        cursor = numnodes;
        numnodes++;
        return true;
    }

    public boolean removeHeader(String name)
    {
        for(int i = 0; i < numnodes; i++)
            if(nodes[i].title.compareTo(name) == 0)
            {
                numnodes--;
                nodes[i] = nodes[numnodes];
                nodes[numnodes].erase();
                return true;
            }

        return false;
    }

    public boolean removeHeader(int pos)
    {
        if(pos < 0 || pos >= numnodes)
            return false;
        if(pos == numnodes - 1)
        {
            numnodes--;
            nodes[numnodes].erase();
        } else
        {
            numnodes--;
            nodes[pos] = nodes[numnodes];
            nodes[numnodes].erase();
        }
        return true;
    }

    public void eraseAll()
    {
        for(int i = 0; i < numnodes; i++)
            nodes[i].erase();

        numnodes = 0;
        cursor = 0;
    }

    public boolean setHeader(String name)
    {
        for(int i = 0; i < numnodes; i++)
            if(nodes[i].title.compareTo(name) == 0)
            {
                cursor = i;
                return true;
            }

        return false;
    }

    public boolean setHeader(int pos)
    {
        if(pos < 0 || pos >= numnodes)
        {
            return false;
        } else
        {
            cursor = pos;
            return true;
        }
    }

    public String getHeader()
    {
        return nodes[cursor].title;
    }

    public boolean addItem(String name, String value)
    {
        if(numnodes == 0)
            return false;
        else
            return nodes[cursor].addItem(name, value);
    }

    public boolean changeItem(String name, String value)
    {
        if(numnodes == 0)
            return false;
        if(!nodes[cursor].changeItem(name, value))
            return addItem(name, value);
        else
            return false;
    }

    public boolean changeItem(int pos, String data)
    {
        if(numnodes == 0)
            return false;
        else
            return nodes[cursor].changeItem(pos, data);
    }

    public String getItem(int pos)
    {
        if(numnodes == 0)
            return new String();
        else
            return nodes[cursor].getItem(pos);
    }

    public String getItem(String value)
    {
        if(numnodes == 0)
            return new String();
        else
            return nodes[cursor].getItem(value);
    }

    public boolean removeItem(String value)
    {
        if(numnodes == 0)
            return false;
        else
            return nodes[cursor].removeItem(value);
    }

    public boolean removeItem(int pos)
    {
        if(numnodes == 0)
            return false;
        else
            return nodes[cursor].removeItem(pos);
    }

    public boolean writeIni(String filename)
    {
        String data = new String();
        try
        {
            FileOutputStream deletefile = new FileOutputStream(filename);
            deletefile.write(0);
            deletefile.close();
        }
        catch(IOException e)
        {
            boolean flag = false;
            return flag;
        }
        RandomAccessFile file;
        try
        {
            file = new RandomAccessFile(filename, "rw");
        }
        catch(IOException e)
        {
            boolean flag1 = false;
            return flag1;
        }
        for(int i = 0; i < numnodes; i++)
        {
            if(nodes[i].numItems() == 0)
                continue;
            data = data + ("[" + nodes[i].title + "]\n");
            for(int j = 0; j < nodes[i].numItems(); j++)
                data = data + (nodes[i].getItemName(j) + " = " + nodes[i].getItem(j) + "\n");

            data = data + "\n";
        }

        try
        {
            file.write(data.getBytes());
            file.close();
        }
        catch(IOException e)
        {
            boolean flag2 = false;
            return flag2;
        }
        return true;
    }

    public boolean readIni(String filename)
    {
        int j = 0;
        eraseAll();
        RandomAccessFile file;
        try
        {
            file = new RandomAccessFile(filename, "r");
        }
        catch(IOException e)
        {
            boolean flag = false;
            return flag;
        }
        do
        {
            String temp;
            try
            {
                temp = file.readLine();
            }
            catch(IOException e)
            {
                boolean flag1 = false;
                return flag1;
            }
            if(temp == null)
                return true;
            if(temp.length() == 1 || temp.length() == 0)
                j = j;
            else
            if(temp.charAt(0) == '[' && temp.charAt(temp.length() - 1) == ']')
            {
                addHeader(temp.substring(1, temp.length() - 1));
            } else
            {
                if(temp.charAt(0) == '[')
                {
                    eraseAll();
                    return false;
                }
                for(j = 0; j < temp.length() && temp.charAt(j) != '='; j++);
                if(j == 0 || j >= temp.length())
                {
                    eraseAll();
                    return false;
                }
                int m = j;
                j++;
                m--;
                for(; j < temp.length() && temp.charAt(j) == ' '; j++);
                for(; m >= 0 && temp.charAt(m) == ' '; m--);
                if(m < 0)
                {
                    eraseAll();
                    return false;
                }
                String rhs = temp.substring(j, temp.length());
                for(int i = 0; i < rhs.length(); i++)
                {
                    if(rhs.charAt(i) != '\n' && rhs.charAt(i) != '\r')
                        continue;
                    if(i + 1 >= rhs.length())
                        rhs = rhs.substring(0, i);
                    else
                        rhs = rhs.substring(0, i) + rhs.substring(i + 1);
                }

                String lhs = temp.substring(0, m + 1);
                addItem(lhs, rhs);
            }
        } while(true);
    }

    public String getData()
    {
        String data = new String();
        for(int i = 0; i < numnodes; i++)
        {
            if(nodes[i].numItems() == 0)
                continue;
            data = data + ("[" + nodes[i].title + "]\n");
            for(int j = 0; j < nodes[i].numItems(); j++)
                data = data + (nodes[i].getItemName(j) + " = " + nodes[i].getItem(j) + "\n");

            data = data + "\n";
        }

        return data;
    }

    protected int numnodes;
    protected int maxnodes;
    protected int cursor;
    protected IniFileNode nodes[];
}
